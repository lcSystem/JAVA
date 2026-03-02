package com.portfolio.infrastructure.rest.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class FileResponse {
    private UUID id;
    private String name;
    private String originalName;
    private UUID folderId;
    private String mimeType;
    private String extension;
    private long sizeBytes;
    private String tags;
    private String fileType;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
