<?php
namespace App\Domain\Repositories;

use App\Domain\Entities\Module;

interface ModuleRepositoryInterface {
    public function findAll(): array;
}
