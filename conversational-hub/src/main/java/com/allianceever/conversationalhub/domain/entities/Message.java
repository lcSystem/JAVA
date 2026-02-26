package com.allianceever.conversationalhub.domain.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Message {
    private String id;
    private String channelId;
    private String senderId;
    private String recipientId;
    private String content;
    private MessageType type;
    private Map<String, Object> metadata;
    private LocalDateTime timestamp;

    public enum MessageType {
        TEXT, CARD, SYSTEM
    }
}
