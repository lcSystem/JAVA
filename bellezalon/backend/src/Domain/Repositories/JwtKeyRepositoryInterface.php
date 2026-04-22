<?php
namespace App\Domain\Repositories;

interface JwtKeyRepositoryInterface {
    public function getLatestKey(): ?array;
    public function findByKid(string $kid): ?array;
    public function rotateKeys(int $maxAgeSeconds = 86400): array;
}
