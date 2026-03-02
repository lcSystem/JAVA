package com.conversationalhub.domain.ports.out;

import com.conversationalhub.infrastructure.mq.dto.ChatNotificationEvent;

public interface NotificationPublisherPort {
    void pushNotification(ChatNotificationEvent event);
}
