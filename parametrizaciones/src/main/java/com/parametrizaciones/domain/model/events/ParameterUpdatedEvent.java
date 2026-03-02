package com.parametrizaciones.domain.model.events;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ParameterUpdatedEvent {
    private String eventId;
    private String serviceName;
    private String key;
    private String value;
    private Integer version;
    private LocalDateTime timestamp;
    private String signature; // For integrity/idempotency
}
