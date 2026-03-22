package com.appointment.application.ports.in;

import com.appointment.domain.model.Appointment;

public interface RespondInvitationUseCase {
    Appointment respond(RespondInvitationCommand command);
}
