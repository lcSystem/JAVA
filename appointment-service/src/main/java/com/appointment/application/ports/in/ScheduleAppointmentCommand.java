package com.appointment.application.ports.in;

import java.time.LocalDateTime;
import java.util.UUID;

import com.appointment.domain.model.AppointmentType;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ScheduleAppointmentCommand {
    private UUID tenantId;
    private String title;

    private String customerId;
    private UUID employeeId;
    private UUID branchId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private AppointmentType type;
    private String notes;
    private String createdBy;
}
