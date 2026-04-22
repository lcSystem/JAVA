<?php
namespace App\Domain\Entities;

class Appointment {
    private ?int $id;
    private int $clienteId;
    private ?int $empleadoId;
    private int $servicioId;
    private string $fechaCita;
    private string $horaCita;
    private string $estado;

    public function __construct(
        ?int $id, 
        int $clienteId, 
        ?int $empleadoId, 
        int $servicioId, 
        string $fechaCita, 
        string $horaCita, 
        string $estado = 'pendiente'
    ) {
        $this->id = $id;
        $this->clienteId = $clienteId;
        $this->empleadoId = $empleadoId;
        $this->servicioId = $servicioId;
        $this->fechaCita = $fechaCita;
        $this->horaCita = $horaCita;
        $this->estado = $estado;
    }

    public function getId(): ?int { return $this->id; }
    public function getClienteId(): int { return $this->clienteId; }
    public function getEmpleadoId(): ?int { return $this->empleadoId; }
    public function getServicioId(): int { return $this->servicioId; }
    public function getFechaCita(): string { return $this->fechaCita; }
    public function getHoraCita(): string { return $this->horaCita; }
    public function getEstado(): string { return $this->estado; }
}
