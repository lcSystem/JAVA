package com.customer.infrastructure.adapter.in.rest.dto;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class CustomerHistoryDto {
    private Long id;
    private String eventType;
    private String description;
    private String createdBy;
    private LocalDateTime createdAt;
}
