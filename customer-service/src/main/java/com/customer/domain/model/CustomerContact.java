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
public class CustomerContact {
    private Long id;
    private Long customerId;
    private String name;
    private String position;
    private String email;
    private String phone;
    private LocalDateTime createdAt;
}
