<?php
namespace App\Domain\Repositories;

use App\Domain\Entities\Role;

interface RoleRepositoryInterface {
    public function findAll(): array;
    public function findById(int $id): ?Role;
    public function save(Role $role): int;
    public function updatePermissions(int $roleId, array $moduleIds): void;
    public function delete(int $id): void;
}
