package com.appointment.application.ports.in;

import java.util.List;
import java.util.UUID;
import com.appointment.domain.model.Availability;

public interface GetAvailabilityUseCase {
    List<Availability> getEmployeeAvailability(UUID employeeId, UUID branchId);

    List<com.appointment.domain.model.Appointment> getEmployeeAppointments(UUID employeeId,
            java.time.LocalDateTime start, java.time.LocalDateTime end);
}
