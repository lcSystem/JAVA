package com.appointment.application.ports.in;

import java.util.UUID;
import lombok.Builder;
import lombok.Data;
import com.appointment.domain.model.AppointmentAttendee.AttendeeStatus;

@Data
@Builder
public class RespondInvitationCommand {
    private UUID appointmentId;
    private UUID userId;
    private AttendeeStatus status;
}
