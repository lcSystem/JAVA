package com.appointment.application.ports.in;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

import com.appointment.domain.model.AppointmentType;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UpdateAppointmentCommand {
    private UUID appointmentId;
    private UUID tenantId;
    private String title;
    private String customerId;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private AppointmentType type;
    private String notes;
    private String updatedBy;
    private List<UUID> attendeeIds;
}
