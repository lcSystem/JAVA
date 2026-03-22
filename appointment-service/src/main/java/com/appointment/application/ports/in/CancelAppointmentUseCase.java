package com.appointment.application.ports.in;

import java.util.UUID;

import com.appointment.domain.model.Appointment;

public interface CancelAppointmentUseCase {
    Appointment cancel(UUID appointmentId);
}
