package com.allianceever.notifications.infrastructure.mq;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

@Component
@Slf4j
@RequiredArgsConstructor
public class NotificationListener {

    private final SimpMessagingTemplate messagingTemplate;

    @RabbitListener(queues = "chat.notifications.queue")
    public void handleChatNotification(ChatNotificationEvent event) {
        log.info("Recibido evento de notificación para el usuario: {}", event.getRecipientId());

        // Enviamos la notificación al usuario específico vía WebSocket
        messagingTemplate.convertAndSendToUser(
                event.getRecipientId(),
                "/queue/notifications",
                event);
    }

    @lombok.Data
    public static class ChatNotificationEvent {
        private String senderId;
        private String recipientId;
        private String messageSnippet;
        private String channelId;
    }
}
