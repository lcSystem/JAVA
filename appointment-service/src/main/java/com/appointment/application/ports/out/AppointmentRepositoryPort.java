package com.appointment.application.ports.out;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import com.appointment.domain.model.Appointment;

public interface AppointmentRepositoryPort {
    Appointment save(Appointment appointment);

    Optional<Appointment> findById(UUID id);

    List<Appointment> findByEmployeeIdAndDateRange(UUID employeeId, LocalDateTime start, LocalDateTime end);

    List<Appointment> findByCustomerId(String customerId);

    boolean existsOverlapping(UUID employeeId, LocalDateTime start, LocalDateTime end);

    boolean existsOverlappingExcluding(UUID employeeId, LocalDateTime start, LocalDateTime end, UUID excludeId);
}
