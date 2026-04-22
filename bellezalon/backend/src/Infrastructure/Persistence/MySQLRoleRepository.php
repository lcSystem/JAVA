<?php
namespace App\Infrastructure\Persistence;

use App\Domain\Entities\Role;
use App\Domain\Entities\Module;
use App\Domain\Repositories\RoleRepositoryInterface;
use PDO;

class MySQLRoleRepository implements RoleRepositoryInterface {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function findAll(): array {
        $stmt = $this->pdo->query("SELECT * FROM `roles` ");
        $roles = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $roles[] = new Role($row['id'], $row['name'], $row['description'], $this->getModulesForRole($row['id']));
        }
        return $roles;
    }

    public function findById(int $id): ?Role {
        $stmt = $this->pdo->prepare("SELECT * FROM `roles`  WHERE `id`  = :id");
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$row) return null;

        return new Role($row['id'], $row['name'], $row['description'], $this->getModulesForRole($row['id']));
    }

    private function getModulesForRole(int $roleId): array {
        $stmt = $this->pdo->prepare("
            SELECT m.* FROM `modules`  m
            JOIN `role_modules`  rm ON m.`id`  = rm.`module_id` 
            WHERE rm.`role_id`  = :role_id
        ");
        $stmt->execute(['role_id' => $roleId]);
        $modules = [];
        while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
            $modules[] = new Module($row['id'], $row['name']);
        }
        return $modules;
    }

    public function save(Role $role): int {
        if ($role->getId()) {
            $stmt = $this->pdo->prepare("UPDATE roles SET name = :name, description = :description WHERE id = :id");
            $stmt->execute([
                'id' => $role->getId(),
                'name' => $role->getName(),
                'description' => $role->getDescription()
            ]);
            return $role->getId();
        } else {
            $stmt = $this->pdo->prepare("INSERT INTO roles (name, description) VALUES (:name, :description)");
            $stmt->execute([
                'name' => $role->getName(),
                'description' => $role->getDescription()
            ]);
            return (int)$this->pdo->lastInsertId();
        }
    }

    public function updatePermissions(int $roleId, array $moduleIds): void {
        $this->pdo->prepare("DELETE FROM role_modules WHERE role_id = :role_id")->execute(['role_id' => $roleId]);
        
        if (empty($moduleIds)) return;

        $stmt = $this->pdo->prepare("INSERT INTO role_modules (role_id, module_id) VALUES (:role_id, :module_id)");
        foreach ($moduleIds as $moduleId) {
            $stmt->execute(['role_id' => $roleId, 'module_id' => $moduleId]);
        }
    }

    public function delete(int $id): void {
        $stmt = $this->pdo->prepare("DELETE FROM roles WHERE id = :id");
        $stmt->execute(['id' => $id]);
    }
}
