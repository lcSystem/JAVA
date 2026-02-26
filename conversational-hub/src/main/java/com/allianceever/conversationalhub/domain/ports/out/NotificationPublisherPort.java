package com.allianceever.conversationalhub.domain.ports.out;

import com.allianceever.conversationalhub.infrastructure.mq.dto.ChatNotificationEvent;

public interface NotificationPublisherPort {
    void pushNotification(ChatNotificationEvent event);
}
