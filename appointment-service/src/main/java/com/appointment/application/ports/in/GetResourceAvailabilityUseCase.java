package com.appointment.application.ports.in;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import com.appointment.domain.model.Availability;
import com.appointment.domain.model.Appointment;

public interface GetResourceAvailabilityUseCase {
    List<Availability> getEmployeeAvailability(UUID employeeId);

    List<Appointment> getEmployeeAppointments(UUID employeeId, LocalDateTime start, LocalDateTime end);
}
