package com.appointment.domain.model;

import java.util.UUID;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentAttendee {
    private UUID id;
    private UUID appointmentId;
    private UUID userId;
    private AttendeeStatus status;

    public enum AttendeeStatus {
        PENDING, ACCEPTED, REJECTED
    }
}
