<?php
namespace App\Domain\Repositories;

use App\Domain\Entities\Appointment;

interface AppointmentRepositoryInterface {
    public function findAll(): array;
    public function save(Appointment $appointment): void;
    public function findByEmployeeId(int $employeeId): array;
    public function cancelPastAppointments(): int;
}
