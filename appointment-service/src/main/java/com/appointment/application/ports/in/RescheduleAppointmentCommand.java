package com.appointment.application.ports.in;

import java.time.LocalDateTime;
import java.util.UUID;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RescheduleAppointmentCommand {
    private UUID appointmentId;
    private UUID tenantId;

    private LocalDateTime newStartTime;
    private LocalDateTime newEndTime;
    private String notes;
    private String createdBy;
}
