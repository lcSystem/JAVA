package com.appointment.infrastructure.adapters.out.rabbitmq;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.appointment.application.ports.out.NotificationPort;
import com.appointment.domain.model.Appointment;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class RabbitMQNotificationAdapter implements NotificationPort {

    private final RabbitTemplate rabbitTemplate;

    @Value("${rabbitmq.exchange.notification:notification-exchange}")
    private String notificationExchange;

    @Value("${rabbitmq.routing.appointment:appointment.notification}")
    private String routingKey;

    @Override
    public void sendAppointmentConfirmation(Appointment appointment) {
        AppointmentNotificationEvent event = buildEvent(appointment, "CONFIRMATION");
        sendEvent(event);
    }

    @Override
    public void sendAppointmentCancellation(Appointment appointment) {
        AppointmentNotificationEvent event = buildEvent(appointment, "CANCELLATION");
        sendEvent(event);
    }

    private void sendEvent(AppointmentNotificationEvent event) {
        try {
            rabbitTemplate.convertAndSend(notificationExchange, routingKey, event);
            log.info("Sent notification event to RabbitMQ: {}", event.getEventType());
        } catch (Exception e) {
            log.error("Failed to send notification event to RabbitMQ", e);
            // In a real environment, we would use RetryTemplate or Outbox Pattern
        }
    }

    private AppointmentNotificationEvent buildEvent(Appointment appointment, String type) {
        return AppointmentNotificationEvent.builder()
                .eventType(type)
                .appointmentId(appointment.getId())
                .title(appointment.getTitle())
                .startTime(appointment.getStartTime())
                .endTime(appointment.getEndTime())
                .type(appointment.getType())
                .branchId(appointment.getBranchId())
                .build();
    }
}
