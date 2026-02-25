package com.allianceever.conversationalhub.domain.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Channel {
    private String id;
    private String tenantId;
    private String name;
    private String description;
    private String erpEntityId;
    private String erpEntityType;
    private LocalDateTime createdAt;
    private boolean isAutomatic;
}
