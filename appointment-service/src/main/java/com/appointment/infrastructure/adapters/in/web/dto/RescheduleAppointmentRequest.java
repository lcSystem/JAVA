package com.appointment.infrastructure.adapters.in.web.dto;

import java.time.LocalDateTime;
import java.util.UUID;
import jakarta.validation.constraints.NotNull;
import lombok.Data;

@Data
public class RescheduleAppointmentRequest {
    @NotNull(message = "Tenant ID is required")
    private UUID tenantId;

    @NotNull(message = "New start time is required")
    private LocalDateTime newStartTime;

    @NotNull(message = "New end time is required")
    private LocalDateTime newEndTime;

    private String notes;
}
