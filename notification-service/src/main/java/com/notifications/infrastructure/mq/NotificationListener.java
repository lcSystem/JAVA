package com.notifications.infrastructure.mq;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

@Component
@Slf4j
@RequiredArgsConstructor
public class NotificationListener {

    private final com.notifications.domain.service.NotificationService notificationService;

    @RabbitListener(queues = "chat.notifications.queue")
    public void handleChatNotification(ChatNotificationEvent event) {
        log.info("Recibido evento de chat para el usuario: {}", event.getRecipientId());

        com.notifications.domain.model.Notification notification = com.notifications.domain.model.Notification.builder()
                .userId(event.getRecipientId())
                .message(event.getMessageSnippet())
                .type(com.notifications.domain.model.NotificationType.CHAT)
                .level(com.notifications.domain.model.NotificationLevel.INFO)
                .extraData(event.getChannelId())
                .build();

        notificationService.createNotification(notification);
    }

    @RabbitListener(queues = "system.notifications.queue")
    public void handleSystemNotification(SystemNotificationEvent event) {
        log.info("Recibido evento de sistema: {}", event.getType());

        com.notifications.domain.model.Notification notification = com.notifications.domain.model.Notification.builder()
                .userId(event.getUserId())
                .message(event.getMessage())
                .type(event.getType())
                .level(event.getLevel())
                .extraData(event.getExtraData())
                .build();

        notificationService.createNotification(notification);
    }

    @lombok.Data
    public static class ChatNotificationEvent {
        private String senderId;
        private String recipientId;
        private String messageSnippet;
        private String channelId;
    }

    @lombok.Data
    public static class SystemNotificationEvent {
        private String userId;
        private String message;
        private com.notifications.domain.model.NotificationType type;
        private com.notifications.domain.model.NotificationLevel level;
        private String extraData;
    }
}
