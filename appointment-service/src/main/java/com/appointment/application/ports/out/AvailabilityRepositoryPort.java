package com.appointment.application.ports.out;

import java.util.List;
import java.util.UUID;

import com.appointment.domain.model.Availability;

public interface AvailabilityRepositoryPort {
    List<Availability> findByEmployeeId(UUID employeeId);

    Availability save(Availability availability);
}
