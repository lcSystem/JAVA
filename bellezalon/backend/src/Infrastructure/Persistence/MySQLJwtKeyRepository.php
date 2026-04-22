<?php
namespace App\Infrastructure\Persistence;

use App\Domain\Repositories\JwtKeyRepositoryInterface;
use PDO;

class MySQLJwtKeyRepository implements JwtKeyRepositoryInterface {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function getLatestKey(): ?array {
        $stmt = $this->pdo->prepare("SELECT * FROM jwt_keys WHERE status = 'active' ORDER BY created_at DESC LIMIT 1");
        $stmt->execute();
        $key = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$key) {
            return $this->generateNewKey();
        }
        
        return $key;
    }

    public function findByKid(string $kid): ?array {
        $stmt = $this->pdo->prepare("SELECT * FROM jwt_keys WHERE kid = :kid LIMIT 1");
        $stmt->execute([':kid' => $kid]);
        return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
    }

    public function rotateKeys(int $maxAgeSeconds = 86400): array {
        // Check if current active key is too old
        $current = $this->getLatestKey();
        $age = time() - strtotime($current['created_at']);
        
        if ($age >= $maxAgeSeconds) {
            // Mark older keys as expired
            $this->pdo->prepare("UPDATE jwt_keys SET status = 'expired' WHERE status = 'active'")->execute();
            return $this->generateNewKey();
        }
        
        return $current;
    }

    private function generateNewKey(): array {
        $kid = bin2hex(random_bytes(16)); // UUID-like 32 chars
        $secret = bin2hex(random_bytes(32)); // 64 chars hex
        
        $stmt = $this->pdo->prepare("INSERT INTO jwt_keys (kid, secret, status) VALUES (:kid, :secret, 'active')");
        $stmt->execute([
            ':kid' => $kid,
            ':secret' => $secret
        ]);
        
        return [
            'kid' => $kid,
            'secret' => $secret,
            'status' => 'active',
            'created_at' => date('Y-m-d H:i:s')
        ];
    }
}
