package com.customer.infrastructure.messaging;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CustomerEvent {
    private String eventType;
    private Long customerId;
    private LocalDateTime timestamp;
    private String source;
}
