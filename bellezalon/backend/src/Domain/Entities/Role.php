<?php
namespace App\Domain\Entities;

class Role {
    private ?int $id;
    private string $name;
    private ?string $description;
    private array $modules; // Array of Module entities

    public function __construct(?int $id, string $name, ?string $description = null, array $modules = []) {
        $this->id = $id;
        $this->name = $name;
        $this->description = $description;
        $this->modules = $modules;
    }

    public function getId(): ?int { return $this->id; }
    public function getName(): string { return $this->name; }
    public function getDescription(): ?string { return $this->description; }
    public function getModules(): array { return $this->modules; }
}
