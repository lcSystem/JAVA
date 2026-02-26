package com.allianceever.notifications.infrastructure.mq;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatNotificationEvent implements Serializable {
    private String senderId;
    private String recipientId;
    private String messageSnippet;
    private String channelId;
}
