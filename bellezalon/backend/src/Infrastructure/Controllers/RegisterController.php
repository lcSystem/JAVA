<?php
namespace App\Infrastructure\Controllers;

use App\Domain\Repositories\UserRepositoryInterface;
use App\Domain\Entities\User;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use PDO;

class RegisterController {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function register(Request $request, Response $response): Response {
        $data = $request->getParsedBody();

        // Validate required fields
        $required = ['username', 'password', 'full_name', 'email', 'phone'];
        foreach ($required as $field) {
            if (empty($data[$field])) {
                $response->getBody()->write(json_encode(['error' => "El campo '$field' es obligatorio"]));
                return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
            }
        }

        // Check if username or email already exists
        $stmt = $this->pdo->prepare("SELECT id FROM users WHERE username = :username OR email = :email");
        $stmt->execute(['username' => $data['username'], 'email' => $data['email']]);
        if ($stmt->fetch()) {
            $response->getBody()->write(json_encode(['error' => 'El nombre de usuario o correo ya están registrados']));
            return $response->withStatus(409)->withHeader('Content-Type', 'application/json');
        }

        // Create user with 'Cliente' role (role_id = 3)
        $hashedPassword = password_hash($data['password'], PASSWORD_DEFAULT);
        $stmt = $this->pdo->prepare("
            INSERT INTO users (username, password, full_name, email, phone, role_id, estado) 
            VALUES (:username, :password, :full_name, :email, :phone, 3, 'inactivo')
        ");
        $stmt->execute([
            'username' => $data['username'],
            'password' => $hashedPassword,
            'full_name' => $data['full_name'],
            'email' => $data['email'],
            'phone' => $data['phone']
        ]);

        $userId = (int)$this->pdo->lastInsertId();

        // Create welcome notification
        $notifStmt = $this->pdo->prepare("
            INSERT INTO notifications (user_id, title, message, type) 
            VALUES (:user_id, 'Cuenta Creada', 'Tu cuenta ha sido creada. Un administrador debe activarla para que puedas iniciar sesión.', 'info')
        ");
        $notifStmt->execute(['user_id' => $userId]);

        $response->getBody()->write(json_encode(['success' => true, 'message' => 'Registro exitoso. Tu cuenta está pendiente de activación por un administrador.']));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    }
}
