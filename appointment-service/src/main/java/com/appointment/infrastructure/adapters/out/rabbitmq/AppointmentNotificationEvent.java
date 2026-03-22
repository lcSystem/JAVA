package com.appointment.infrastructure.adapters.out.rabbitmq;

import com.appointment.domain.model.AppointmentType;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class AppointmentNotificationEvent {
    private String eventType; // "CONFIRMATION" or "CANCELLATION"
    private UUID appointmentId;
    private String title;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private AppointmentType type;
    private UUID branchId;
}
