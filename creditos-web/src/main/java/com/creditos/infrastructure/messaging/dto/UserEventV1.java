package com.creditos.infrastructure.messaging.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserEventV1 {
    private Long userId;
    private String username;
    private String email;
    private boolean active;
    private String action; // CREATED, UPDATED, DELETED
}
