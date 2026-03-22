package com.appointment.application.ports.in;

import com.appointment.domain.model.Appointment;

public interface ScheduleAppointmentUseCase {
    Appointment schedule(ScheduleAppointmentCommand command);
}
