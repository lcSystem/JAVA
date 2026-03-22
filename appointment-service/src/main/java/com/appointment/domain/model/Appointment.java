package com.appointment.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Pure Domain Entity representing an Appointment across the boundary.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Appointment {
    private UUID id;
    private UUID tenantId;
    private String title;
    private String customerId;
    private UUID employeeId;
    private UUID branchId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private AppointmentStatus status;
    private AppointmentType type;
    private String notes;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private String createdBy;

    private boolean isDeleted;
    private String timezone;
    private Integer duration;

    public void softDelete() {
        this.isDeleted = true;
        this.updatedAt = LocalDateTime.now();
    }

    public void confirm() {
        if (this.status == AppointmentStatus.CANCELLED || this.status == AppointmentStatus.COMPLETED
                || this.status == AppointmentStatus.NO_SHOW) {
            throw new IllegalStateException("Cannot confirm an appointment in its current state.");
        }
        this.status = AppointmentStatus.CONFIRMED;
        this.updatedAt = LocalDateTime.now();
    }

    public void cancel() {
        if (this.status == AppointmentStatus.COMPLETED) {
            throw new IllegalStateException("Cannot cancel a completed appointment.");
        }
        this.status = AppointmentStatus.CANCELLED;
        this.updatedAt = LocalDateTime.now();
    }

    public void complete() {
        if (this.status != AppointmentStatus.CONFIRMED) {
            throw new IllegalStateException("Only confirmed appointments can be marked as completed.");
        }
        this.status = AppointmentStatus.COMPLETED;
        this.updatedAt = LocalDateTime.now();
    }
}
