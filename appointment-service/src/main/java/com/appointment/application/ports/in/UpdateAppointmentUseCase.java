package com.appointment.application.ports.in;

import com.appointment.domain.model.Appointment;

public interface UpdateAppointmentUseCase {
    Appointment update(UpdateAppointmentCommand command);
}
