package com.projectERP.AuthenticatedBackend.infrastructure.messaging.publisher;

import com.projectERP.AuthenticatedBackend.infrastructure.messaging.dto.SystemNotificationEvent;
import com.projectERP.AuthenticatedBackend.infrastructure.configuration.RabbitMQConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class SystemNotificationPublisher {

    private final RabbitTemplate rabbitTemplate;

    public void publishNotification(SystemNotificationEvent event) {
        log.info("Publishing system notification for user: {}", event.getUserId());
        rabbitTemplate.convertAndSend(RabbitMQConfig.SYSTEM_NOTIFICATION_EXCHANGE, "", event);
    }
}
