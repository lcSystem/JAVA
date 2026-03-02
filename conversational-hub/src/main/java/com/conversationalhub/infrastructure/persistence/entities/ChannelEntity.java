package com.conversationalhub.infrastructure.persistence.entities;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.SQLDelete;
import org.hibernate.annotations.Where;

import java.time.LocalDateTime;

@Entity
@Table(name = "channels")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@SQLDelete(sql = "UPDATE channels SET deleted_at = NOW() WHERE id = ?")
@Where(clause = "deleted_at IS NULL")
public class ChannelEntity {
    @Id
    private String id;
    private String tenantId;
    private String name;
    private String description;
    private String erpEntityId;
    private String erpEntityType;
    private LocalDateTime createdAt;
    private LocalDateTime deletedAt;
    private boolean isAutomatic;
}
