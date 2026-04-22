<?php
namespace App\Domain\Repositories;

use App\Domain\Entities\User;

interface UserRepositoryInterface {
    public function findById(int $id): ?User;
    public function findByUsername(string $username): ?User;
    public function findAll(): array;
    public function save(User $user): void;
    public function delete(int $id): void;
    public function recordLogin(int $userId, string $ip, string $userAgent, ?float $lat = null, ?float $lng = null, ?string $city = null, ?string $neighborhood = null): int;
    public function deactivateSession(int $id): void;
    public function isSessionActive(int $id): bool;
}
