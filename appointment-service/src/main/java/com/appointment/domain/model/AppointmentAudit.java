package com.appointment.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentAudit {
    private UUID id;
    private UUID tenantId;
    private UUID appointmentId;
    private String action; // CREATE, UPDATE, CANCEL, RESCHEDULE
    private String oldStatus;
    private String newStatus;
    private LocalDateTime changedAt;
    private String changedBy;
}
