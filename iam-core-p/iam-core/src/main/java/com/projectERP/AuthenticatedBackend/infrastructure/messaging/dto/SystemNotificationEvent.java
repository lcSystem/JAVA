package com.projectERP.AuthenticatedBackend.infrastructure.messaging.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SystemNotificationEvent {
    private String userId;
    private String message;
    private NotificationType type;
    private NotificationLevel level;
    private String extraData;
}
