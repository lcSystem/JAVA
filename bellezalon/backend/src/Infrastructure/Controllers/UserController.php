<?php
namespace App\Infrastructure\Controllers;

use App\Domain\Repositories\UserRepositoryInterface;
use App\Domain\Repositories\RoleRepositoryInterface;
use App\Domain\Entities\User;
use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;

class UserController {
    private UserRepositoryInterface $userRepository;
    private RoleRepositoryInterface $roleRepository;
    private \PDO $pdo;

    public function __construct(UserRepositoryInterface $userRepository, RoleRepositoryInterface $roleRepository, \PDO $pdo) {
        $this->userRepository = $userRepository;
        $this->roleRepository = $roleRepository;
        $this->pdo = $pdo;
    }

    public function getAll(Request $request, Response $response): Response {
        try {
            $users = $this->userRepository->findAll();
            error_log("UserController::getAll - returning " . count($users) . " users");
            $response->getBody()->write(json_encode($users));
            return $response->withHeader('Content-Type', 'application/json');
        } catch (\Exception $e) {
            error_log("UserController::getAll ERROR: " . $e->getMessage());
            $response->getBody()->write(json_encode(['error' => $e->getMessage()]));
            return $response->withStatus(500)->withHeader('Content-Type', 'application/json');
        }
    }

    public function getEmpleados(Request $request, Response $response): Response {
        $users = $this->userRepository->findAll();
        $empleados = array_values(array_filter($users, function($u) {
            return $u['role_id'] != 3 && $u['role_id'] != 1 && $u['estado'] === 'activo';
        }));
        $response->getBody()->write(json_encode($empleados));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getClientes(Request $request, Response $response): Response {
        $users = $this->userRepository->findAll();
        $clientes = array_values(array_filter($users, function($u) {
            return $u['role_id'] == 3 && $u['estado'] === 'activo';
        }));
        $response->getBody()->write(json_encode($clientes));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function create(Request $request, Response $response): Response {
        $data = $request->getParsedBody();

        if (empty($data['username']) || empty($data['password'])) {
            $response->getBody()->write(json_encode(['error' => 'Username and password are required']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        $existing = $this->userRepository->findByUsername($data['username']);
        if ($existing) {
            $response->getBody()->write(json_encode(['error' => 'Username already exists']));
            return $response->withStatus(409)->withHeader('Content-Type', 'application/json');
        }

        $hashedPassword = password_hash($data['password'], PASSWORD_DEFAULT);
        $roleId = (int)($data['role_id'] ?? 2);
        
        $fullName = $data['full_name'] ?? null;
        $email = $data['email'] ?? null;
        $phone = $data['phone'] ?? null;

        $user = new User(null, $data['username'], $hashedPassword, $roleId, null, [], 'activo', $fullName, $email, $phone);
        $this->userRepository->save($user);

        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    }

    public function update(Request $request, Response $response, array $args): Response {
        $id = (int)$args['id'];
        $data = $request->getParsedBody();

        $existing = $this->userRepository->findById($id);
        if (!$existing) {
            $response->getBody()->write(json_encode(['error' => 'User not found']));
            return $response->withStatus(404)->withHeader('Content-Type', 'application/json');
        }

        $password = $existing->getPassword();
        if (!empty($data['password'])) {
            $password = password_hash($data['password'], PASSWORD_DEFAULT);
        }

        $roleId = (int)($data['role_id'] ?? $existing->getRoleId());
        $username = $data['username'] ?? $existing->getUsername();
        $estado = $data['estado'] ?? $existing->getEstado();

        $fullName = array_key_exists('full_name', $data) ? $data['full_name'] : $existing->getFullName();
        $email = array_key_exists('email', $data) ? $data['email'] : $existing->getEmail();
        $phone = array_key_exists('phone', $data) ? $data['phone'] : $existing->getPhone();

        $user = new User($id, $username, $password, $roleId, null, [], $estado, $fullName, $email, $phone);
        $this->userRepository->save($user);

        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function delete(Request $request, Response $response, array $args): Response {
        $id = (int)$args['id'];
        $this->userRepository->delete($id);
        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function updateFcmToken(Request $request, Response $response, array $args): Response {
        $id = (int)$args['id'];
        $data = $request->getParsedBody();
        $token = $data['fcm_token'] ?? null;

        if (!$token) {
            $response->getBody()->write(json_encode(['error' => 'Token is required']));
            return $response->withStatus(400)->withHeader('Content-Type', 'application/json');
        }

        try {
            // Check if column exists, if not add it
            $res = $this->pdo->query("SHOW COLUMNS FROM users LIKE 'fcm_token'");
            if ($res->rowCount() === 0) {
                $this->pdo->exec("ALTER TABLE users ADD COLUMN fcm_token VARCHAR(255) DEFAULT NULL");
            }
            
            $stmt = $this->pdo->prepare("UPDATE users SET fcm_token = :token WHERE id = :id");
            $stmt->execute([':token' => $token, ':id' => $id]);

            $response->getBody()->write(json_encode(['success' => true]));
            return $response->withHeader('Content-Type', 'application/json');
        } catch (\Exception $e) {
            error_log("FCM Token Error: " . $e->getMessage());
            $response->getBody()->write(json_encode(['error' => $e->getMessage()]));
            return $response->withStatus(500)->withHeader('Content-Type', 'application/json');
        }
    }
}
