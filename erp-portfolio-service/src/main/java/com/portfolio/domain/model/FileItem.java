package com.portfolio.domain.model;

import com.portfolio.domain.enums.FileType;
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
public class FileItem {
    private UUID id;
    private String name;
    private String originalName;
    private UUID folderId;
    private String ownerId;
    private String storagePath;
    private String mimeType;
    private String extension;
    private long sizeBytes;
    private String checksum;
    private String tags;
    private FileType fileType;
    private boolean deleted;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
