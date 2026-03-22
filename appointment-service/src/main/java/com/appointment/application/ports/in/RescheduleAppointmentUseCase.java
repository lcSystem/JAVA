package com.appointment.application.ports.in;

import com.appointment.domain.model.Appointment;

public interface RescheduleAppointmentUseCase {
    Appointment reschedule(RescheduleAppointmentCommand command);
}
