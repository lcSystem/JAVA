<?php
namespace App\Domain\Repositories;

use App\Domain\Entities\Setting;

interface SettingsRepositoryInterface {
    public function getAll(): array;
    public function findByKey(string $key): ?Setting;
    public function update(string $key, string $value): void;
}
