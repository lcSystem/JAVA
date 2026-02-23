package com.allianceever.portfolio.application.services;

import com.allianceever.portfolio.domain.enums.FileType;
import com.allianceever.portfolio.domain.exception.*;
import com.allianceever.portfolio.domain.exception.FileNotFoundException;
import com.allianceever.portfolio.domain.model.FileItem;
import com.allianceever.portfolio.domain.model.FileVersion;
import com.allianceever.portfolio.domain.model.Folder;
import com.allianceever.portfolio.domain.model.PortfolioSettings;
import com.allianceever.portfolio.domain.ports.in.FileUseCase;
import com.allianceever.portfolio.domain.ports.in.SettingsUseCase;
import com.allianceever.portfolio.domain.ports.out.FileRepositoryPort;
import com.allianceever.portfolio.domain.ports.out.FolderRepositoryPort;
import com.allianceever.portfolio.domain.ports.out.StoragePort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.io.InputStream;
import java.security.MessageDigest;
import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
public class FileUseCaseImpl implements FileUseCase {

    private final FileRepositoryPort fileRepository;
    private final FolderRepositoryPort folderRepository;
    private final StoragePort storagePort;
    private final SettingsUseCase settingsUseCase;

    @Override
    public FileItem uploadFile(String originalName, long sizeBytes, String mimeType,
            InputStream inputStream, UUID folderId, String ownerId) {

        // Validate settings
        PortfolioSettings settings = settingsUseCase.getSettings();
        long maxBytes = (long) settings.getMaxFileSizeMb() * 1024 * 1024;
        if (sizeBytes > maxBytes) {
            throw new FileSizeExceededException(
                    "File size " + sizeBytes + " bytes exceeds maximum " + settings.getMaxFileSizeMb() + "MB");
        }

        String extension = extractExtension(originalName);
        if (!settings.getAllowedExtensions().isEmpty() &&
                !settings.getAllowedExtensions().contains(extension.toLowerCase())) {
            throw new FileExtensionNotAllowedException(
                    "Extension '" + extension + "' is not allowed. Allowed: " + settings.getAllowedExtensions());
        }

        // Validate folder exists & ownership
        if (folderId != null) {
            Folder folder = folderRepository.findById(folderId)
                    .orElseThrow(() -> new FolderNotFoundException("Folder not found: " + folderId));
            if (!folder.getOwnerId().equals(ownerId)) {
                throw new UnauthorizedAccessException("You don't have access to this folder");
            }
        }

        // Build storage path
        UUID fileId = UUID.randomUUID();
        String storagePath = buildStoragePath(ownerId, folderId, fileId, extension);

        // Store the file (streaming)
        String actualPath = storagePort.store(inputStream, storagePath);

        // Detect file type from MIME
        FileType fileType = detectFileType(mimeType, extension);

        // Auto-generate tags (AI stub: uses extension + MIME type heuristics)
        String tags = generateTags(originalName, mimeType, fileType);

        FileItem fileItem = FileItem.builder()
                .id(fileId)
                .name(originalName)
                .originalName(originalName)
                .folderId(folderId)
                .ownerId(ownerId)
                .storagePath(actualPath)
                .mimeType(mimeType)
                .extension(extension)
                .sizeBytes(sizeBytes)
                .tags(tags)
                .fileType(fileType)
                .deleted(false)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        FileItem saved = fileRepository.save(fileItem);

        // Create initial version
        FileVersion version = FileVersion.builder()
                .id(UUID.randomUUID())
                .fileId(saved.getId())
                .versionNumber(1)
                .storagePath(actualPath)
                .sizeBytes(sizeBytes)
                .createdBy(ownerId)
                .createdAt(LocalDateTime.now())
                .build();
        fileRepository.saveVersion(version);

        log.info("Uploaded file {} ({} bytes) to storage path {}", originalName, sizeBytes, storagePath);
        return saved;
    }

    @Override
    public InputStream downloadFile(UUID fileId, String ownerId) {
        FileItem file = getFileOrThrow(fileId);
        validateOwnership(file, ownerId);
        return storagePort.retrieve(file.getStoragePath());
    }

    @Override
    public FileItem renameFile(UUID fileId, String newName, String ownerId) {
        FileItem file = getFileOrThrow(fileId);
        validateOwnership(file, ownerId);

        file.setName(newName);
        file.setUpdatedAt(LocalDateTime.now());
        return fileRepository.save(file);
    }

    @Override
    public void softDeleteFile(UUID fileId, String ownerId) {
        FileItem file = getFileOrThrow(fileId);
        validateOwnership(file, ownerId);
        fileRepository.softDeleteById(fileId);
        log.info("Soft deleted file {}", fileId);
    }

    @Override
    public void hardDeleteFile(UUID fileId, String ownerId) {
        FileItem file = getFileOrThrow(fileId);
        validateOwnership(file, ownerId);

        // Delete all versions from storage
        List<FileVersion> versions = fileRepository.findVersionsByFileId(fileId);
        for (FileVersion v : versions) {
            storagePort.delete(v.getStoragePath());
        }

        // Delete physical file
        storagePort.delete(file.getStoragePath());
        fileRepository.deleteById(fileId);
        log.info("Hard deleted file {} and {} versions", fileId, versions.size());
    }

    @Override
    public FileItem moveFile(UUID fileId, UUID newFolderId, String ownerId) {
        FileItem file = getFileOrThrow(fileId);
        validateOwnership(file, ownerId);

        if (newFolderId != null) {
            Folder newFolder = folderRepository.findById(newFolderId)
                    .orElseThrow(() -> new FolderNotFoundException("Target folder not found: " + newFolderId));
            if (!newFolder.getOwnerId().equals(ownerId)) {
                throw new UnauthorizedAccessException("You don't have access to the target folder");
            }
        }

        String oldPath = file.getStoragePath();
        String newPath = buildStoragePath(ownerId, newFolderId, file.getId(), file.getExtension());

        // Perform physical move of the file and its versions (if versioning is simple)
        // Note: Currently we only move the main version. If multiple versions had
        // different paths, we'd need more logic.
        // But buildStoragePath includes folderId, so moving folder implies moving the
        // physical file.
        storagePort.move(oldPath, newPath);

        file.setFolderId(newFolderId);
        file.setStoragePath(newPath);
        file.setUpdatedAt(LocalDateTime.now());

        // Also update the version path (assuming only 1 version for now or all follow
        // same path pattern)
        // In a more robust system, we would iterate and update all version paths if
        // they were folder-dependent.
        List<FileVersion> versions = fileRepository.findVersionsByFileId(fileId);
        for (FileVersion v : versions) {
            if (v.getStoragePath().equals(oldPath)) {
                v.setStoragePath(newPath);
                fileRepository.saveVersion(v);
            }
        }

        log.info("Moved file {} from {} to {}", fileId, oldPath, newPath);
        return fileRepository.save(file);
    }

    @Override
    public Page<FileItem> listFilesByFolder(UUID folderId, String ownerId, Pageable pageable) {
        return fileRepository.findByFolderIdAndNotDeleted(folderId, pageable);
    }

    @Override
    public Page<FileItem> listRootFiles(String ownerId, Pageable pageable) {
        return fileRepository.findRootFilesByOwner(ownerId, pageable);
    }

    @Override
    public FileItem getFileById(UUID fileId, String ownerId) {
        FileItem file = getFileOrThrow(fileId);
        validateOwnership(file, ownerId);
        return file;
    }

    @Override
    public List<FileVersion> getFileVersions(UUID fileId, String ownerId) {
        FileItem file = getFileOrThrow(fileId);
        validateOwnership(file, ownerId);
        return fileRepository.findVersionsByFileId(fileId);
    }

    // ─── Helper methods ─────────────────────────────────────────────

    private FileItem getFileOrThrow(UUID fileId) {
        return fileRepository.findById(fileId)
                .orElseThrow(() -> new FileNotFoundException("File not found: " + fileId));
    }

    private void validateOwnership(FileItem file, String ownerId) {
        if (!file.getOwnerId().equals(ownerId)) {
            throw new UnauthorizedAccessException("You don't have access to this file");
        }
    }

    private String extractExtension(String filename) {
        int lastDot = filename.lastIndexOf('.');
        if (lastDot == -1 || lastDot == filename.length() - 1) {
            return "";
        }
        return filename.substring(lastDot + 1).toLowerCase();
    }

    private String buildStoragePath(String ownerId, UUID folderId, UUID fileId, String extension) {
        String folderPart = folderId != null ? folderId.toString() : "root";
        return ownerId + "/" + folderPart + "/" + fileId.toString() + "." + extension;
    }

    /**
     * AI stub: detects file type from MIME type and extension using heuristics.
     * Replace with ML model or external API in the future via port abstraction.
     */
    private FileType detectFileType(String mimeType, String extension) {
        if (mimeType != null) {
            if (mimeType.startsWith("image/"))
                return FileType.IMAGE;
            if (mimeType.equals("application/pdf"))
                return FileType.PDF;
            if (mimeType.contains("word") || mimeType.contains("document"))
                return FileType.DOCUMENT;
            if (mimeType.contains("spreadsheet") || mimeType.contains("excel"))
                return FileType.SPREADSHEET;
            if (mimeType.contains("presentation") || mimeType.contains("powerpoint"))
                return FileType.PRESENTATION;
        }

        // Fallback to extension
        return switch (extension.toLowerCase()) {
            case "jpg", "jpeg", "png", "gif", "bmp", "svg", "webp" -> FileType.IMAGE;
            case "pdf" -> FileType.PDF;
            case "doc", "docx", "odt", "rtf", "txt" -> FileType.DOCUMENT;
            case "xls", "xlsx", "ods", "csv" -> FileType.SPREADSHEET;
            case "ppt", "pptx", "odp" -> FileType.PRESENTATION;
            default -> FileType.OTHER;
        };
    }

    /**
     * AI stub: generates tags based on filename, MIME type, and detected type.
     * Future: integrate NLP/ML for content-based tagging.
     */
    private String generateTags(String filename, String mimeType, FileType fileType) {
        List<String> tags = new ArrayList<>();
        tags.add(fileType.name().toLowerCase());

        if (mimeType != null) {
            String mainType = mimeType.split("/")[0];
            if (!tags.contains(mainType)) {
                tags.add(mainType);
            }
        }

        // Extract meaningful words from filename (AI stub)
        String nameWithoutExt = filename.contains(".")
                ? filename.substring(0, filename.lastIndexOf('.'))
                : filename;
        String[] words = nameWithoutExt.split("[_\\-\\s]+");
        for (String word : words) {
            if (word.length() > 2) {
                tags.add(word.toLowerCase());
            }
        }

        return String.join(",", tags);
    }
}
