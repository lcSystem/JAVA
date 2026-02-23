package com.allianceever.portfolio.domain.ports.in;

import com.allianceever.portfolio.domain.model.FileItem;
import com.allianceever.portfolio.domain.model.FileVersion;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.io.InputStream;
import java.util.List;
import java.util.UUID;

public interface FileUseCase {

    FileItem uploadFile(String originalName, long sizeBytes, String mimeType,
            InputStream inputStream, UUID folderId, String ownerId);

    InputStream downloadFile(UUID fileId, String ownerId);

    FileItem renameFile(UUID fileId, String newName, String ownerId);

    void softDeleteFile(UUID fileId, String ownerId);

    void hardDeleteFile(UUID fileId, String ownerId);

    FileItem moveFile(UUID fileId, UUID newFolderId, String ownerId);

    Page<FileItem> listFilesByFolder(UUID folderId, String ownerId, Pageable pageable);

    Page<FileItem> listRootFiles(String ownerId, Pageable pageable);

    FileItem getFileById(UUID fileId, String ownerId);

    List<FileVersion> getFileVersions(UUID fileId, String ownerId);
}
