package com.conversationalhub.infrastructure.mq;

import com.conversationalhub.domain.ports.out.NotificationPublisherPort;
import com.conversationalhub.infrastructure.mq.dto.ChatNotificationEvent;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class RabbitNotificationPublisher implements NotificationPublisherPort {

    private final RabbitTemplate rabbitTemplate;

    // Exchange para notificaciones
    public static final String NOTIFICATION_EXCHANGE = "chat.notifications.exchange";

    @Override
    public void pushNotification(ChatNotificationEvent event) {
        rabbitTemplate.convertAndSend(NOTIFICATION_EXCHANGE, "", event);
    }
}
