<?php
namespace App\Infrastructure;

use Psr\Http\Message\ResponseInterface as Response;
use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface as Handler;
use PDO;

class RateLimitMiddleware implements MiddlewareInterface {
    private PDO $pdo;
    private int $limit;
    private int $window;

    public function __construct(PDO $pdo, int $limit = 60, int $windowSeconds = 60) {
        $this->pdo = $pdo;
        $this->limit = $limit;
        $this->window = $windowSeconds;
        $this->ensureTableExists();
    }

    private function ensureTableExists() {
        $this->pdo->exec("CREATE TABLE IF NOT EXISTS rate_limits (
            ip VARCHAR(45) PRIMARY KEY,
            requests INT DEFAULT 1,
            reset_at TIMESTAMP
        )");
    }

    public function process(Request $request, Handler $handler): Response {
        $ip = $request->getServerParams()['REMOTE_ADDR'] ?? 'unknown';
        
        $stmt = $this->pdo->prepare("SELECT * FROM rate_limits WHERE ip = :ip");
        $stmt->execute([':ip' => $ip]);
        $data = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($data && strtotime($data['reset_at']) > time()) {
            if ($data['requests'] >= $this->limit) {
                $response = new \Slim\Psr7\Response();
                $response->getBody()->write(json_encode(['error' => 'Demasiadas peticiones. Intente más tarde.']));
                return $response->withStatus(429)->withHeader('Content-Type', 'application/json');
            }
            
            $this->pdo->prepare("UPDATE rate_limits SET requests = requests + 1 WHERE ip = :ip")->execute([':ip' => $ip]);
        } else {
            $resetAt = date('Y-m-d H:i:s', time() + $this->window);
            $this->pdo->prepare("INSERT INTO rate_limits (ip, requests, reset_at) 
                                 VALUES (:ip, 1, :reset) 
                                 ON DUPLICATE KEY UPDATE requests = 1, reset_at = :reset")
                      ->execute([':ip' => $ip, ':reset' => $resetAt]);
        }

        return $handler->handle($request);
    }
}
