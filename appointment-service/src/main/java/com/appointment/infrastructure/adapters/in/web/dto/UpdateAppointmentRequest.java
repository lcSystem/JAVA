package com.appointment.infrastructure.adapters.in.web.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import com.appointment.domain.model.AppointmentType;

import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class UpdateAppointmentRequest {
    @NotNull(message = "Tenant ID is required")
    private UUID tenantId;

    @NotNull(message = "Title is required")
    private String title;

    @NotNull(message = "Customer ID is required")
    private String customerId;

    @NotNull(message = "Start time is required")
    private LocalDateTime startTime;

    @NotNull(message = "End time is required")
    private LocalDateTime endTime;

    @NotNull(message = "Appointment type is required")
    private AppointmentType type;

    private String notes;

    private List<UUID> attendeeIds;
}
