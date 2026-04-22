<?php
namespace App\Application\UseCases;

use App\Domain\Entities\Appointment;
use App\Domain\Repositories\AppointmentRepositoryInterface;

class BookAppointmentUseCase {
    private AppointmentRepositoryInterface $repository;

    public function __construct(AppointmentRepositoryInterface $repository) {
        $this->repository = $repository;
    }

    public function execute(int $userId, int $employeeId, int $serviceId, string $dateStr): Appointment {
        $date = new \DateTime($dateStr);
        
        if (!$this->repository->checkAvailability($employeeId, $date)) {
            throw new \Exception("Employee is not available at the selected time.");
        }

        $appointment = new Appointment(null, $userId, $employeeId, $serviceId, $date);
        $this->repository->save($appointment);
        
        return $appointment;
    }
}
