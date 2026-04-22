<?php
namespace App\Infrastructure\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use PDO;

class ChatController {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
        $this->ensureTableExists();
    }

    private function ensureTableExists() {
        $sql = "CREATE TABLE IF NOT EXISTS chat_messages (
            id INT AUTO_INCREMENT PRIMARY KEY,
            cita_id INT NOT NULL,
            sender_id INT NOT NULL,
            message TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (cita_id) REFERENCES citas(id) ON DELETE CASCADE,
            FOREIGN KEY (sender_id) REFERENCES users(id) ON DELETE CASCADE
        )";
        $this->pdo->exec($sql);
    }

    public function getMessages(Request $request, Response $response, array $args): Response {
        $citaId = $args['citaId'];
        $userId = $request->getAttribute('user_id');
        $userRole = $request->getAttribute('user_role');
        $isAdmin = in_array(strtolower($userRole), ['administrador', 'admin']);

        // IDOR Prevention: Check if user is participant
        $stmtCheck = $this->pdo->prepare("SELECT cliente_id, empleado_id FROM citas WHERE id = :id");
        $stmtCheck->execute([':id' => $citaId]);
        $cita = $stmtCheck->fetch(PDO::FETCH_ASSOC);

        if (!$cita) {
            $response->getBody()->write(json_encode(['error' => 'Cita no encontrada']));
            return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
        }

        if (!$isAdmin && $cita['cliente_id'] != $userId && $cita['empleado_id'] != $userId) {
            $response->getBody()->write(json_encode(['error' => 'No tienes permiso para ver este chat']));
            return $response->withStatus(403)->withHeader('Content-Type', 'application/json');
        }
        
        $stmt = $this->pdo->prepare("
            SELECT cm.*, u.username as sender_name, u.full_name as sender_fullname 
            FROM chat_messages cm
            JOIN users u ON cm.sender_id = u.id
            WHERE cm.cita_id = :cita_id
            ORDER BY cm.created_at ASC
        ");
        $stmt->execute([':cita_id' => $citaId]);
        $messages = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $response->getBody()->write(json_encode($messages));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function sendMessage(Request $request, Response $response, array $args): Response {
        $citaId = $args['citaId'];
        $userId = $request->getAttribute('user_id');
        $data = $request->getParsedBody();
        $senderId = $userId; // IDOR & Mass Assignment fix: Use authenticated userId, not from body
        $message = $data['message'];

        // Verify appointment status
        $stmtCita = $this->pdo->prepare("SELECT estado, cliente_id, empleado_id FROM citas WHERE id = :id");
        $stmtCita->execute([':id' => $citaId]);
        $cita = $stmtCita->fetch(PDO::FETCH_ASSOC);

        if (!$cita || !in_array($cita['estado'], ['pendiente', 'confirmada'])) {
            $response->getBody()->write(json_encode(['error' => 'El chat solo está disponible para citas pendientes o confirmadas.']));
            return $response->withStatus(403)->withHeader('Content-Type', 'application/json');
        }

        // Save message
        $stmt = $this->pdo->prepare("INSERT INTO chat_messages (cita_id, sender_id, message) VALUES (:cid, :sid, :msg)");
        $stmt->execute([
            ':cid' => $citaId,
            ':sid' => $senderId,
            ':msg' => $message
        ]);

        // Persist as Notification
        $recipientId = ($senderId == $cita['cliente_id']) ? $cita['empleado_id'] : $cita['cliente_id'];
        if ($recipientId) {
            $senderStmt = $this->pdo->prepare("SELECT COALESCE(full_name, username) as name FROM users WHERE id = :id");
            $senderStmt->execute([':id' => $senderId]);
            $senderName = $senderStmt->fetch(PDO::FETCH_ASSOC)['name'] ?? 'Alguien';

            $title = "Mensaje de $senderName";
            $notifStmt = $this->pdo->prepare("INSERT INTO notifications (user_id, title, message, type, context_id, context_type) VALUES (:uid, :t, :m, 'chat', :cid, 'chat')");
            $notifStmt->execute([':uid' => $recipientId, ':t' => $title, ':m' => $message, ':cid' => $citaId]);

            // Push Notification Logic
            $this->sendPushToUser($recipientId, $title, $message, [
                'cita_id' => (string)$citaId, 
                'type' => 'chat'
            ]);
        }

        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    }

    public function getMyChats(Request $request, Response $response): Response {
        $userId = $request->getAttribute('user_id');
        $userRole = $request->getAttribute('user_role');

        $sql = "SELECT c.id as cita_id, c.fecha_cita, c.hora_cita, c.estado, 
                       u_cl.full_name as cliente_nombre, 
                       COALESCE(u_em.full_name, 'No asignado') as empleado_nombre,
                       (SELECT message FROM chat_messages WHERE cita_id = c.id ORDER BY created_at DESC LIMIT 1) as last_message
                FROM citas c
                JOIN users u_cl ON c.cliente_id = u_cl.id
                LEFT JOIN users u_em ON c.empleado_id = u_em.id";
        
        $params = [];
        if ($userRole !== 'Administrador') { // Not Admin
            $sql .= " WHERE c.cliente_id = :uid OR c.empleado_id = :uid";
            $params[':uid'] = $userId;
        }

        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        $chats = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $response->getBody()->write(json_encode($chats));
        return $response->withHeader('Content-Type', 'application/json');
    }

    private function sendPushToUser($userId, $title, $body, $data) {
        $stmt = $this->pdo->prepare("SELECT fcm_token FROM users WHERE id = :id");
        $stmt->execute([':id' => $userId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row && !empty($row['fcm_token'])) {
            $serviceAccountFile = __DIR__ . '/../firebase-service-account.json';
            if (file_exists($serviceAccountFile)) {
                require_once __DIR__ . '/../Services/FcmService.php';
                $fcm = new \App\Infrastructure\Services\FcmService($serviceAccountFile);
                $fcm->sendToToken($row['fcm_token'], $title, $body, $data);
            }
        }
    }
}
