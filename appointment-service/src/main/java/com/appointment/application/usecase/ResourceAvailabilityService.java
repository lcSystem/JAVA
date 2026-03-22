package com.appointment.application.usecase;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import com.appointment.application.ports.in.GetResourceAvailabilityUseCase;
import com.appointment.application.ports.out.AppointmentRepositoryPort;
import com.appointment.application.ports.out.AvailabilityRepositoryPort;
import com.appointment.domain.model.Appointment;
import com.appointment.domain.model.Availability;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class ResourceAvailabilityService implements GetResourceAvailabilityUseCase {

    private final AvailabilityRepositoryPort availabilityRepository;
    private final AppointmentRepositoryPort appointmentRepository;

    @Override
    public List<Availability> getEmployeeAvailability(UUID employeeId) {
        return availabilityRepository.findByEmployeeId(employeeId);
    }

    @Override
    public List<Appointment> getEmployeeAppointments(UUID employeeId, LocalDateTime start, LocalDateTime end) {
        return appointmentRepository.findByEmployeeIdAndDateRange(employeeId, start, end);
    }
}
