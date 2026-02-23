package com.allianceever.portfolio.infrastructure.rest.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class FileVersionResponse {
    private UUID id;
    private UUID fileId;
    private int versionNumber;
    private long sizeBytes;
    private String checksum;
    private String createdBy;
    private LocalDateTime createdAt;
}
