<?php
namespace App\Infrastructure\Persistence;

use App\Domain\Entities\Setting;
use App\Domain\Repositories\SettingsRepositoryInterface;
use PDO;

class MySQLSettingsRepository implements SettingsRepositoryInterface {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function getAll(): array {
        $stmt = $this->pdo->query("SELECT * FROM app_settings");
        $results = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $results[] = new Setting($row['key_name'], $row['setting_value'], $row['category']);
        }
        return $results;
    }

    public function findByKey(string $key): ?Setting {
        $stmt = $this->pdo->prepare("SELECT * FROM app_settings WHERE key_name = :key");
        $stmt->execute(['key' => $key]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$row) return null;
        return new Setting($row['key_name'], $row['setting_value'], $row['category']);
    }

    public function update(string $key, string $value): void {
        $check = $this->pdo->prepare("SELECT COUNT(*) FROM app_settings WHERE key_name = :key");
        $check->execute(['key' => $key]);
        if ($check->fetchColumn() > 0) {
            $stmt = $this->pdo->prepare("UPDATE app_settings SET setting_value = :value WHERE key_name = :key");
        } else {
            $stmt = $this->pdo->prepare("INSERT INTO app_settings (key_name, setting_value, category) VALUES (:key, :value, 'GENERAL')");
        }
        $stmt->execute(['key' => $key, 'value' => $value]);
    }
}
