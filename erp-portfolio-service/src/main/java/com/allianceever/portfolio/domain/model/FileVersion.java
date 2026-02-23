package com.allianceever.portfolio.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FileVersion {
    private UUID id;
    private UUID fileId;
    private int versionNumber;
    private String storagePath;
    private long sizeBytes;
    private String checksum;
    private String createdBy;
    private LocalDateTime createdAt;
}
