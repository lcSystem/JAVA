package com.portfolio.infrastructure.rest.dto;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class FolderResponse {
    private UUID id;
    private String name;
    private UUID parentId;
    private String path;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
