package com.appointment.infrastructure.adapters.in.web.dto;

import java.time.LocalDateTime;
import java.util.UUID;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class AppointmentResponse {
    private UUID id;
    private String title;
    private String customerId;
    private UUID employeeId;
    private UUID branchId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private String status;
    private String type;
    private String notes;
    private String customerName;
}
