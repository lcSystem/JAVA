package com.appointment.infrastructure.adapters.out.persistence.entity;

import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "appointment_audit")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AppointmentAuditEntity {
    @Id
    private UUID id;
    private UUID tenantId;
    private UUID appointmentId;
    private String action;
    private String oldStatus;
    private String newStatus;
    private LocalDateTime changedAt;
    private String changedBy;
}
