<?php
namespace App\Infrastructure\Controllers;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use PDO;

class NotificationController {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function getForUser(Request $request, Response $response, array $args): Response {
        $userId = (int)$args['userId'];
        $stmt = $this->pdo->prepare("
            SELECT * FROM notifications 
            WHERE user_id = :user_id OR user_id IS NULL
            ORDER BY created_at DESC 
            LIMIT 50
        ");
        $stmt->execute(['user_id' => $userId]);
        $notifs = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $response->getBody()->write(json_encode($notifs));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function getUnreadCount(Request $request, Response $response, array $args): Response {
        $userId = (int)$args['userId'];
        $stmt = $this->pdo->prepare("
            SELECT COUNT(*) as count FROM notifications 
            WHERE (user_id = :user_id OR user_id IS NULL) AND is_read = 0
        ");
        $stmt->execute(['user_id' => $userId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        $response->getBody()->write(json_encode(['count' => (int)$row['count']]));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function markAsRead(Request $request, Response $response, array $args): Response {
        $id = (int)$args['id'];
        $stmt = $this->pdo->prepare("UPDATE notifications SET is_read = 1 WHERE id = :id");
        $stmt->execute(['id' => $id]);

        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function markAllRead(Request $request, Response $response, array $args): Response {
        $userId = (int)$args['userId'];
        $stmt = $this->pdo->prepare("UPDATE notifications SET is_read = 1 WHERE user_id = :user_id OR user_id IS NULL");
        $stmt->execute(['user_id' => $userId]);

        $response->getBody()->write(json_encode(['success' => true]));
        return $response->withHeader('Content-Type', 'application/json');
    }

    public function create(Request $request, Response $response): Response {
        $stmt = $this->pdo->prepare("
            INSERT INTO notifications (user_id, title, message, type, context_id, context_type) 
            VALUES (:user_id, :title, :message, :type, :context_id, :context_type)
        ");
        $stmt->execute([
            'user_id' => $data['user_id'] ?? null,
            'title' => $data['title'],
            'message' => $data['message'],
            'type' => $data['type'] ?? 'info',
            'context_id' => $data['context_id'] ?? null,
            'context_type' => $data['context_type'] ?? null
        ]);

        $response->getBody()->write(json_encode(['success' => true, 'id' => (int)$this->pdo->lastInsertId()]));
        return $response->withStatus(201)->withHeader('Content-Type', 'application/json');
    }

    public function getAll(Request $request, Response $response): Response {
        $userId = $request->getAttribute('user_id');
        $userRole = $request->getAttribute('user_role');
        $queryParams = $request->getQueryParams();
        
        $search = $queryParams['search'] ?? null;
        $filterUserId = $queryParams['user_id'] ?? null;
        $unreadOnly = isset($queryParams['unread_only']) && ($queryParams['unread_only'] === '1' || $queryParams['unread_only'] === 'true');
        $isAdmin = in_array(strtolower($userRole), ['administrador', 'admin']);

        $sql = "SELECT n.*, u.username, u.full_name 
                FROM notifications n 
                LEFT JOIN users u ON n.user_id = u.id 
                WHERE 1=1";
        $params = [];

        if (!$isAdmin) {
            $sql .= " AND (n.user_id = :uid OR n.user_id IS NULL)";
            $params[':uid'] = $userId;
        } else {
            if ($filterUserId) {
                $sql .= " AND n.user_id = :filter_uid";
                $params[':filter_uid'] = $filterUserId;
            }
        }

        if ($unreadOnly) {
            $sql .= " AND n.is_read = 0";
        }

        if ($search) {
            $sql .= " AND (n.title LIKE :search OR n.message LIKE :search OR u.username LIKE :search OR u.full_name LIKE :search)";
            $params[':search'] = "%$search%";
        }

        $sql .= " ORDER BY n.created_at DESC LIMIT 100";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute($params);
        $notifs = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $response->getBody()->write(json_encode($notifs));
        return $response->withHeader('Content-Type', 'application/json');
    }
}
