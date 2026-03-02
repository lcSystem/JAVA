package com.portfolio.infrastructure.persistence.entities;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "portfolio_file_version")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FileVersionJpaEntity {

    @Id
    @Column(columnDefinition = "BINARY(16)")
    private byte[] id;

    @Column(name = "file_id", nullable = false, columnDefinition = "BINARY(16)")
    private byte[] fileId;

    @Column(name = "version_number", nullable = false)
    private int versionNumber;

    @Column(name = "storage_path", nullable = false, columnDefinition = "TEXT")
    private String storagePath;

    @Column(name = "size_bytes", nullable = false)
    private long sizeBytes;

    @Column(length = 64)
    private String checksum;

    @Column(name = "created_by", length = 100)
    private String createdBy;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}
