<?php
namespace App\Domain\Entities;

class Employee {
    private ?int $id;
    private string $nombre;
    private string $especialidad;
    private ?int $usuarioId;

    public function __construct(?int $id, string $nombre, string $especialidad, ?int $usuarioId = null) {
        $this->id = $id;
        $this->nombre = $nombre;
        $this->especialidad = $especialidad;
        $this->usuarioId = $usuarioId;
    }

    public function getId(): ?int { return $this->id; }
    public function getNombre(): string { return $this->nombre; }
    public function getEspecialidad(): string { return $this->especialidad; }
    public function getUsuarioId(): ?int { return $this->usuarioId; }
}
