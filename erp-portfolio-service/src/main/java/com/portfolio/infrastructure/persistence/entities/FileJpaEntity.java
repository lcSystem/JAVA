package com.portfolio.infrastructure.persistence.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "portfolio_file")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FileJpaEntity {

    @Id
    @Column(columnDefinition = "BINARY(16)")
    private byte[] id;

    @Column(nullable = false)
    private String name;

    @Column(name = "original_name", nullable = false)
    private String originalName;

    @Column(name = "folder_id", columnDefinition = "BINARY(16)")
    private byte[] folderId;

    @Column(name = "owner_id", nullable = false, length = 100)
    private String ownerId;

    @Column(name = "storage_path", nullable = false, columnDefinition = "TEXT")
    private String storagePath;

    @Column(name = "mime_type", length = 100)
    private String mimeType;

    @Column(length = 20)
    private String extension;

    @Column(name = "size_bytes", nullable = false)
    private long sizeBytes;

    @Column(length = 64)
    private String checksum;

    @Column(columnDefinition = "TEXT")
    private String tags;

    @Column(name = "file_type", length = 50)
    private String fileType;

    @Column(nullable = false)
    private boolean deleted = false;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}
