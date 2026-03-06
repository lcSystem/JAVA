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
public class CustomerNote {
    private Long id;
    private Long customerId;
    private String note;
    private String createdBy;
    private LocalDateTime createdAt;
}
