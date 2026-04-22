<?php
namespace App\Infrastructure\Persistence;

use App\Domain\Entities\User;
use App\Domain\Repositories\UserRepositoryInterface;
use PDO;

class MySQLUserRepository implements UserRepositoryInterface {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function findById(int $id): ?User {
        $stmt = $this->pdo->prepare("
            SELECT u.*, r.name as role_name 
            FROM users u
            LEFT JOIN roles r ON u.role_id = r.id
            WHERE u.id = :id
        ");
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$row) return null;

        $permissions = $this->getPermissionsForRole($row['role_id']);
        return new User(
            $row['id'], 
            $row['username'], 
            $row['password'], 
            (int)$row['role_id'], 
            $row['role_name'], 
            $permissions, 
            $row['estado'] ?? 'activo',
            $row['full_name'] ?? null,
            $row['email'] ?? null,
            $row['phone'] ?? null,
            $row['city'] ?? null,
            $row['neighborhood'] ?? null,
            $row['address'] ?? null,
            $row['avatar_url'] ?? null,
            $row['technical_sheet'] ?? null
        );
    }

    public function findByUsername(string $username): ?User {
        $stmt = $this->pdo->prepare("
            SELECT u.*, r.name as role_name 
            FROM users u
            LEFT JOIN roles r ON u.role_id = r.id
            WHERE u.username = :username
        ");
        $stmt->execute(['username' => $username]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$row) return null;

        $permissions = $this->getPermissionsForRole($row['role_id']);
        return new User(
            $row['id'], 
            $row['username'], 
            $row['password'], 
            (int)$row['role_id'], 
            $row['role_name'], 
            $permissions, 
            $row['estado'] ?? 'activo',
            $row['full_name'] ?? null,
            $row['email'] ?? null,
            $row['phone'] ?? null,
            $row['city'] ?? null,
            $row['neighborhood'] ?? null,
            $row['address'] ?? null,
            $row['avatar_url'] ?? null,
            $row['technical_sheet'] ?? null
        );
    }

    private function getPermissionsForRole(int $roleId): array {
        $stmt = $this->pdo->prepare("
            SELECT m.name FROM modules m
            JOIN role_modules rm ON m.id = rm.module_id
            WHERE rm.role_id = :role_id
        ");
        $stmt->execute(['role_id' => $roleId]);
        return $stmt->fetchAll(PDO::FETCH_COLUMN);
    }

    public function findAll(): array {
        try {
            // Auto-repair: ensure all expected columns exist
            $this->ensureUserColumns();

            $stmt = $this->pdo->query("
                SELECT u.id, u.username, u.role_id, u.estado, u.full_name, u.email, u.phone, u.city, u.neighborhood, u.address, u.avatar_url, u.technical_sheet, r.name as role_name
                FROM users u
                LEFT JOIN roles r ON u.role_id = r.id
                ORDER BY u.id
            ");
            $users = [];
            while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                $users[] = [
                    'id' => (int)$row['id'],
                    'username' => $row['username'] ?? '',
                    'role_id' => (int)($row['role_id'] ?? 2),
                    'role_name' => $row['role_name'] ?? 'Sin rol',
                    'estado' => $row['estado'] ?? 'activo',
                    'full_name' => $row['full_name'] ?? null,
                    'email' => $row['email'] ?? null,
                    'phone' => $row['phone'] ?? null,
                    'city' => $row['city'] ?? null,
                    'neighborhood' => $row['neighborhood'] ?? null,
                    'address' => $row['address'] ?? null,
                    'avatar_url' => $row['avatar_url'] ?? null,
                    'technical_sheet' => $row['technical_sheet'] ?? null
                ];
            }
            return $users;
        } catch (\Exception $e) {
            error_log("findAll users error: " . $e->getMessage());
            // Fallback: try minimal query with only core columns
            try {
                $stmt = $this->pdo->query("
                    SELECT u.id, u.username, u.role_id, u.estado, r.name as role_name
                    FROM users u
                    LEFT JOIN roles r ON u.role_id = r.id
                    ORDER BY u.id
                ");
                $users = [];
                while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
                    $users[] = [
                        'id' => (int)$row['id'],
                        'username' => $row['username'] ?? '',
                        'role_id' => (int)($row['role_id'] ?? 2),
                        'role_name' => $row['role_name'] ?? 'Sin rol',
                        'estado' => $row['estado'] ?? 'activo',
                        'full_name' => null,
                        'email' => null,
                        'phone' => null,
                        'city' => null,
                        'neighborhood' => null,
                        'address' => null,
                        'avatar_url' => null,
                        'technical_sheet' => null
                    ];
                }
                error_log("findAll users FALLBACK succeeded with " . count($users) . " users");
                return $users;
            } catch (\Exception $e2) {
                error_log("findAll users FALLBACK also failed: " . $e2->getMessage());
                return [];
            }
        }
    }

    /**
     * Ensures all expected columns exist in the users table.
     * Adds missing columns automatically.
     */
    private function ensureUserColumns(): void {
        static $checked = false;
        if ($checked) return;
        $checked = true;

        $expectedColumns = [
            'full_name' => "VARCHAR(255) DEFAULT NULL",
            'email' => "VARCHAR(150) DEFAULT NULL",
            'phone' => "VARCHAR(20) DEFAULT NULL",
            'city' => "VARCHAR(100) DEFAULT NULL",
            'neighborhood' => "VARCHAR(100) DEFAULT NULL",
            'address' => "VARCHAR(255) DEFAULT NULL",
            'avatar_url' => "VARCHAR(255) DEFAULT NULL",
            'technical_sheet' => "TEXT DEFAULT NULL",
            'estado' => "ENUM('activo', 'inactivo') DEFAULT 'activo'",
            'fcm_token' => "VARCHAR(255) DEFAULT NULL"
        ];

        try {
            $stmt = $this->pdo->query("DESCRIBE users");
            $existingColumns = $stmt->fetchAll(PDO::FETCH_COLUMN);

            foreach ($expectedColumns as $col => $definition) {
                if (!in_array($col, $existingColumns)) {
                    try {
                        $this->pdo->exec("ALTER TABLE users ADD COLUMN $col $definition");
                        error_log("ensureUserColumns: added missing column '$col'");
                    } catch (\Exception $e) {
                        error_log("ensureUserColumns: failed to add column '$col': " . $e->getMessage());
                    }
                }
            }
        } catch (\Exception $e) {
            error_log("ensureUserColumns: " . $e->getMessage());
        }
    }

    public function save(User $user): void {
        if ($user->getId()) {
            $stmt = $this->pdo->prepare("UPDATE users SET username = :username, password = :password, role_id = :role_id, estado = :estado, full_name = :full_name, email = :email, phone = :phone, city = :city, neighborhood = :neighborhood, address = :address, avatar_url = :avatar_url, technical_sheet = :technical_sheet WHERE id = :id");
            $stmt->execute([
                'id' => $user->getId(),
                'username' => $user->getUsername(),
                'password' => $user->getPassword(),
                'role_id' => $user->getRoleId(),
                'estado' => $user->getEstado(),
                'full_name' => $user->getFullName(),
                'email' => $user->getEmail(),
                'phone' => $user->getPhone(),
                'city' => $user->getCity(),
                'neighborhood' => $user->getNeighborhood(),
                'address' => $user->getAddress(),
                'avatar_url' => $user->getAvatarUrl(),
                'technical_sheet' => $user->getTechnicalSheet()
            ]);
        } else {
            $stmt = $this->pdo->prepare("INSERT INTO users (username, password, role_id, estado, full_name, email, phone, city, neighborhood, address, avatar_url, technical_sheet) VALUES (:username, :password, :role_id, :estado, :full_name, :email, :phone, :city, :neighborhood, :address, :avatar_url, :technical_sheet)");
            $stmt->execute([
                'username' => $user->getUsername(),
                'password' => $user->getPassword(),
                'role_id' => $user->getRoleId(),
                'estado' => $user->getEstado(),
                'full_name' => $user->getFullName(),
                'email' => $user->getEmail(),
                'phone' => $user->getPhone(),
                'city' => $user->getCity(),
                'neighborhood' => $user->getNeighborhood(),
                'address' => $user->getAddress(),
                'avatar_url' => $user->getAvatarUrl(),
                'technical_sheet' => $user->getTechnicalSheet()
            ]);
        }
    }

    public function delete(int $id): void {
        $stmt = $this->pdo->prepare("DELETE FROM users WHERE id = :id");
        $stmt->execute(['id' => $id]);
    }

    public function recordLogin(int $userId, string $ip, string $userAgent, ?float $lat = null, ?float $lng = null, ?string $city = null, ?string $neighborhood = null): int {
        $stmt = $this->pdo->prepare("INSERT INTO login_logs (user_id, ip_address, user_agent, latitude, longitude, city, neighborhood) VALUES (:userId, :ip, :ua, :lat, :lng, :city, :nb)");
        $stmt->execute([
            'userId' => $userId,
            'ip' => $ip,
            'ua' => $userAgent,
            'lat' => $lat,
            'lng' => $lng,
            'city' => $city,
            'nb' => $neighborhood
        ]);
        return (int)$this->pdo->lastInsertId();
    }

    public function deactivateSession(int $id): void {
        $stmt = $this->pdo->prepare("UPDATE login_logs SET is_active = 0 WHERE id = :id");
        $stmt->execute(['id' => $id]);
    }

    public function isSessionActive(int $id): bool {
        $stmt = $this->pdo->prepare("SELECT is_active FROM login_logs WHERE id = :id");
        $stmt->execute(['id' => $id]);
        $val = $stmt->fetchColumn();
        return $val === false || (int)$val === 1;
    }
}
