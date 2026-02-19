package com.allianceever.projectERP.AuthenticatedBackend.infrastructure.messaging.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EventEnvelope<T> {
    private String eventId;
    private String eventType;
    private String version;
    private LocalDateTime timestamp;
    private T payload;
    private String signature;
    private String source;
}
