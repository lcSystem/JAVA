package com.allianceever.portfolio.infrastructure.persistence.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "portfolio_folder")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FolderJpaEntity {

    @Id
    @Column(columnDefinition = "BINARY(16)")
    private byte[] id;

    @Column(nullable = false)
    private String name;

    @Column(name = "parent_id", columnDefinition = "BINARY(16)")
    private byte[] parentId;

    @Column(name = "owner_id", nullable = false, length = 100)
    private String ownerId;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String path;

    @Column(nullable = false)
    private boolean deleted = false;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
