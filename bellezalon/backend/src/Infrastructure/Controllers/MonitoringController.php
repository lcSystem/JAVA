<?php
namespace App\Infrastructure\Controllers;

use PDO;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class MonitoringController {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function getLoginLogs(Request $request, Response $response): Response {
        $sql = "SELECT l.*, u.username, u.full_name 
                FROM login_logs l
                JOIN users u ON l.user_id = u.id
                ORDER BY l.login_at DESC
                LIMIT 100";
        
        $stmt = $this->pdo->query($sql);
        $logs = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $response->getBody()->write(json_encode($logs));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function logoutRemote(Request $request, Response $response, array $args): Response {
        $id = $args['id'];
        
        $stmt = $this->pdo->prepare("UPDATE login_logs SET is_active = 0 WHERE id = :id");
        $stmt->execute(['id' => $id]);

        $response->getBody()->write(json_encode(['message' => 'Sesión terminada correctamente']));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getSucursales(Request $request, Response $response): Response {
        $stmt = $this->pdo->query("SELECT * FROM sucursales ORDER BY nombre ASC");
        $sucursales = $stmt->fetchAll(PDO::FETCH_ASSOC);
        $response->getBody()->write(json_encode($sucursales));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function createSucursal(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        if (empty($data['nombre']) || empty($data['departamento']) || empty($data['ciudad']) || empty($data['direccion'])) {
            $response->getBody()->write(json_encode(['error' => 'Faltan campos obligatorios (nombre, departamento, ciudad o direccion)']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $barrio = !empty($data['barrio']) ? $data['barrio'] : 'N/A';
        $pais = !empty($data['pais']) ? $data['pais'] : 'Colombia';

        $stmt = $this->pdo->prepare("INSERT INTO sucursales (nombre, pais, departamento, ciudad, barrio, direccion, latitud, longitud) VALUES (:nom, :pais, :dep, :ciu, :bar, :dir, :lat, :lng)");
        $stmt->execute([
            ':nom' => $data['nombre'],
            ':pais' => $pais,
            ':dep' => $data['departamento'],
            ':ciu' => $data['ciudad'],
            ':bar' => $barrio,
            ':dir' => $data['direccion'],
            ':lat' => isset($data['latitud']) ? (float)$data['latitud'] : null,
            ':lng' => isset($data['longitud']) ? (float)$data['longitud'] : null,
        ]);

        $data['id'] = $this->pdo->lastInsertId();

        // Broadcast notification
        $title = 'Nueva Sucursal';
        $msg = "Se ha agregado una nueva sucursal: {$data['nombre']}";
        $notifStmt = $this->pdo->prepare("INSERT INTO notifications (user_id, title, message, type) VALUES (NULL, :title, :msg, 'info')");
        $notifStmt->execute([':title' => $title, ':msg' => $msg]);

        // FCM Broadcast
        $serviceAccountFile = __DIR__ . '/../firebase-service-account.json';
        if (file_exists($serviceAccountFile)) {
            require_once __DIR__ . '/../Services/FcmService.php';
            $fcmService = new \App\Infrastructure\Services\FcmService($serviceAccountFile);
            $fcmService->sendToTopic("all", $title, $msg);
        }

        $response->getBody()->write(json_encode($data));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    }

    public function updateSucursal(Request $request, Response $response, array $args): Response {
        $id = $args['id'];
        $data = $request->getParsedBody();
        
        $sql = "UPDATE sucursales SET nombre = :nom, pais = :pais, departamento = :dep, ciudad = :ciu, barrio = :bar, direccion = :dir, latitud = :lat, longitud = :lng WHERE id = :id";
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute([
            ':id' => $id,
            ':nom' => $data['nombre'],
            ':pais' => !empty($data['pais']) ? $data['pais'] : 'Colombia',
            ':dep' => $data['departamento'],
            ':ciu' => $data['ciudad'],
            ':bar' => !empty($data['barrio']) ? $data['barrio'] : 'N/A',
            ':dir' => $data['direccion'],
            ':lat' => isset($data['latitud']) ? (float)$data['latitud'] : null,
            ':lng' => isset($data['longitud']) ? (float)$data['longitud'] : null,
        ]);

        // Broadcast notification
        $title = 'Actualización de Sucursal';
        $msg = "La sucursal {$data['nombre']} ha sido actualizada.";
        $notifStmt = $this->pdo->prepare("INSERT INTO notifications (user_id, title, message, type) VALUES (NULL, :title, :msg, 'info')");
        $notifStmt->execute([':title' => $title, ':msg' => $msg]);

        // FCM Broadcast
        $serviceAccountFile = __DIR__ . '/../firebase-service-account.json';
        if (file_exists($serviceAccountFile)) {
            require_once __DIR__ . '/../Services/FcmService.php';
            $fcmService = new \App\Infrastructure\Services\FcmService($serviceAccountFile);
            $fcmService->sendToTopic("all", $title, $msg);
        }

        $response->getBody()->write(json_encode(['message' => 'Sucursal actualizada']));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function deleteSucursal(Request $request, Response $response, array $args): Response {
        $id = $args['id'];
        $stmt = $this->pdo->prepare("DELETE FROM sucursales WHERE id = :id");
        $stmt->execute([':id' => $id]);
        $response->getBody()->write(json_encode(['message' => 'Sucursal eliminada']));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
