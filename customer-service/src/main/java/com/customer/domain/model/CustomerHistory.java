package com.customer.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CustomerHistory {
    private Long id;
    private Long customerId;
    private String eventType;
    private String description;
    private String createdBy;
    private LocalDateTime createdAt;
}
