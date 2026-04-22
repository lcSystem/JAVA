<?php
namespace App\Infrastructure\Persistence;

use App\Domain\Entities\Appointment;
use App\Domain\Repositories\AppointmentRepositoryInterface;
use PDO;

class MySQLAppointmentRepository implements AppointmentRepositoryInterface {
    private PDO $pdo;

    public function __construct(PDO $pdo) {
        $this->pdo = $pdo;
    }

    public function findAll(): array {
        $stmt = $this->pdo->query("SELECT * FROM citas ORDER BY fecha_cita DESC, hora_cita ASC");
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        return array_map(function($row) {
            return new Appointment(
                $row['id'],
                $row['cliente_id'],
                $row['empleado_id'],
                $row['servicio_id'],
                $row['fecha_cita'],
                $row['hora_cita'],
                $row['estado']
            );
        }, $results);
    }

    public function save(Appointment $appointment): void {
        $stmt = $this->pdo->prepare("
            INSERT INTO citas (cliente_id, empleado_id, servicio_id, fecha_cita, hora_cita, estado) 
            VALUES (?, ?, ?, ?, ?, ?)
        ");
        $stmt->execute([
            $appointment->getClienteId(),
            $appointment->getEmpleadoId(),
            $appointment->getServicioId(),
            $appointment->getFechaCita(),
            $appointment->getHoraCita(),
            $appointment->getEstado()
        ]);
    }

    public function findByEmployeeId(int $employeeId): array {
        $stmt = $this->pdo->prepare("SELECT * FROM citas WHERE empleado_id = ?");
        $stmt->execute([$employeeId]);
        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        return array_map(function($row) {
            return new Appointment(
                $row['id'],
                $row['cliente_id'],
                $row['empleado_id'],
                $row['servicio_id'],
                $row['fecha_cita'],
                $row['hora_cita'],
                $row['estado']
            );
        }, $results);
    }

    public function cancelPastAppointments(): int {
        // Query for appointments where date is past and status is not 'completado' or 'cancelada'
        $sql = "UPDATE citas 
                SET estado = 'cancelada' 
                WHERE (fecha_cita < CURDATE() OR (fecha_cita = CURDATE() AND hora_cita < CURTIME()))
                AND estado NOT IN ('completado', 'cancelada')";
        
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute();
        
        return $stmt->rowCount();
    }
}
