<?php
namespace App\Infrastructure\Persistence;

use App\Domain\Entities\Module;
use App\Domain\Repositories\ModuleRepositoryInterface;
use PDO;

class MySQLModuleRepository implements ModuleRepositoryInterface {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function findAll(): array {
        $stmt = $this->pdo->query("SELECT * FROM `modules` ");
        $modules = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $modules[] = new Module($row['id'], $row['name']);
        }
        return $modules;
    }
}
