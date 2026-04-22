<?php
namespace App\Infrastructure\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use PDO;

class PqrsController {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function getAll(Request $request, Response $response): Response {
        $userId = $request->getAttribute('user_id');
        $userRole = strtolower($request->getAttribute('user_role') ?? '');

        // Clients see only their own. Admin and Employees see all.
        $query = "
            SELECT p.*, COALESCE(u.full_name, u.username) AS autor_nombre
            FROM pqrs p
            JOIN users u ON p.user_id = u.id
        ";
        
        $params = [];
        if (in_array($userRole, ['cliente', 'customer'])) {
            $query .= " WHERE p.user_id = :uid";
            $params[':uid'] = $userId;
        }
        
        $query .= " ORDER BY p.created_at DESC";

        $stmt = $this->pdo->prepare($query);
        $stmt->execute($params);
        $pqrs = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        $response->getBody()->write(json_encode($pqrs));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getById(Request $request, Response $response, array $args): Response {
        $id = $args['id'];
        $userId = $request->getAttribute('user_id');
        $userRole = strtolower($request->getAttribute('user_role') ?? '');

        // Get PQRS header
        $stmt = $this->pdo->prepare("
            SELECT p.*, COALESCE(u.full_name, u.username) AS autor_nombre
            FROM pqrs p
            JOIN users u ON p.user_id = u.id
            WHERE p.id = :id
        ");
        $stmt->execute([':id' => $id]);
        $pqrs = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$pqrs) {
            $response->getBody()->write(json_encode(['error' => 'PQRS no encontrado']));
            return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
        }

        // Check permissions
        if (in_array($userRole, ['cliente', 'customer']) && $pqrs['user_id'] != $userId) {
            $response->getBody()->write(json_encode(['error' => 'No tienes permiso para ver este reporte']));
            return $response->withStatus(403)->withHeader('Content-Type', 'application/json');
        }

        // Get Responses
        $stmtResp = $this->pdo->prepare("
            SELECT r.*, COALESCE(u.full_name, u.username) AS autor_nombre, u.role_id
            FROM pqrs_respuestas r
            JOIN users u ON r.user_id = u.id
            WHERE r.pqrs_id = :id
            ORDER BY r.created_at ASC
        ");
        $stmtResp->execute([':id' => $id]);
        $pqrs['respuestas'] = $stmtResp->fetchAll(PDO::FETCH_ASSOC);

        $response->getBody()->write(json_encode($pqrs));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function create(Request $request, Response $response): Response {
        $data = $request->getParsedBody();
        $userId = $request->getAttribute('user_id');

        if (empty($data['tipo']) || empty($data['asunto']) || empty($data['descripcion'])) {
            $response->getBody()->write(json_encode(['error' => 'Todos los campos son obligatorios']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $stmt = $this->pdo->prepare("INSERT INTO pqrs (user_id, tipo, asunto, descripcion, estado) VALUES (:uid, :tipo, :asunto, :desc, 'abierto')");
        $stmt->execute([
            ':uid' => $userId,
            ':tipo' => $data['tipo'],
            ':asunto' => $data['asunto'],
            ':desc' => $data['descripcion']
        ]);

        $id = $this->pdo->lastInsertId();
        
        $response->getBody()->write(json_encode(['id' => $id, 'message' => 'PQRS creado exitosamente']));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    }

    public function addRespuesta(Request $request, Response $response, array $args): Response {
        $id = $args['id'];
        $data = $request->getParsedBody();
        $userId = $request->getAttribute('user_id');

        if (empty($data['mensaje'])) {
            $response->getBody()->write(json_encode(['error' => 'El mensaje no puede estar vacío']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        // Verify PQRS existence and permissions (optional check, owner or staff)
        $stmt = $this->pdo->prepare("INSERT INTO pqrs_respuestas (pqrs_id, user_id, mensaje) VALUES (:pid, :uid, :msg)");
        $stmt->execute([
            ':pid' => $id,
            ':uid' => $userId,
            ':msg' => $data['mensaje']
        ]);

        $response->getBody()->write(json_encode(['message' => 'Respuesta añadida']));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    }

    public function updateStatus(Request $request, Response $response, array $args): Response {
        $id = $args['id'];
        $data = $request->getParsedBody();
        $userRole = strtolower($request->getAttribute('user_role') ?? '');

        if (!in_array($userRole, ['administrador', 'admin', 'empleado', 'staff'])) {
            $response->getBody()->write(json_encode(['error' => 'Solo el personal puede cambiar el estado']));
            return $response->withStatus(403)->withHeader('Content-Type', 'application/json');
        }

        if (empty($data['estado'])) {
            $response->getBody()->write(json_encode(['error' => 'El estado es requerido']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $stmt = $this->pdo->prepare("UPDATE pqrs SET estado = :est WHERE id = :id");
        $stmt->execute([':est' => $data['estado'], ':id' => $id]);

        $response->getBody()->write(json_encode(['message' => 'Estado actualizado']));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
