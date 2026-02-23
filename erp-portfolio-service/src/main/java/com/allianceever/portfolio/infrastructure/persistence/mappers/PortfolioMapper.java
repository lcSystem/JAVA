package com.allianceever.portfolio.infrastructure.persistence.mappers;

import com.allianceever.portfolio.domain.enums.FileType;
import com.allianceever.portfolio.domain.model.FileItem;
import com.allianceever.portfolio.domain.model.FileVersion;
import com.allianceever.portfolio.domain.model.Folder;
import com.allianceever.portfolio.infrastructure.persistence.entities.FileJpaEntity;
import com.allianceever.portfolio.infrastructure.persistence.entities.FileVersionJpaEntity;
import com.allianceever.portfolio.infrastructure.persistence.entities.FolderJpaEntity;
import org.springframework.stereotype.Component;

import java.nio.ByteBuffer;
import java.util.UUID;

@Component
public class PortfolioMapper {

    // ─── UUID ↔ byte[] conversion ────────────────────────────────────

    public byte[] uuidToBytes(UUID uuid) {
        if (uuid == null)
            return null;
        ByteBuffer bb = ByteBuffer.wrap(new byte[16]);
        bb.putLong(uuid.getMostSignificantBits());
        bb.putLong(uuid.getLeastSignificantBits());
        return bb.array();
    }

    public UUID bytesToUuid(byte[] bytes) {
        if (bytes == null)
            return null;
        ByteBuffer bb = ByteBuffer.wrap(bytes);
        long high = bb.getLong();
        long low = bb.getLong();
        return new UUID(high, low);
    }

    // ─── Folder mapping ─────────────────────────────────────────────

    public Folder toDomain(FolderJpaEntity entity) {
        if (entity == null)
            return null;
        return Folder.builder()
                .id(bytesToUuid(entity.getId()))
                .name(entity.getName())
                .parentId(bytesToUuid(entity.getParentId()))
                .ownerId(entity.getOwnerId())
                .path(entity.getPath())
                .deleted(entity.isDeleted())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }

    public FolderJpaEntity toJpaEntity(Folder domain) {
        if (domain == null)
            return null;
        return FolderJpaEntity.builder()
                .id(uuidToBytes(domain.getId()))
                .name(domain.getName())
                .parentId(uuidToBytes(domain.getParentId()))
                .ownerId(domain.getOwnerId())
                .path(domain.getPath())
                .deleted(domain.isDeleted())
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .build();
    }

    // ─── File mapping ───────────────────────────────────────────────

    public FileItem toDomain(FileJpaEntity entity) {
        if (entity == null)
            return null;
        return FileItem.builder()
                .id(bytesToUuid(entity.getId()))
                .name(entity.getName())
                .originalName(entity.getOriginalName())
                .folderId(bytesToUuid(entity.getFolderId()))
                .ownerId(entity.getOwnerId())
                .storagePath(entity.getStoragePath())
                .mimeType(entity.getMimeType())
                .extension(entity.getExtension())
                .sizeBytes(entity.getSizeBytes())
                .checksum(entity.getChecksum())
                .tags(entity.getTags())
                .fileType(entity.getFileType() != null ? FileType.valueOf(entity.getFileType()) : FileType.OTHER)
                .deleted(entity.isDeleted())
                .createdAt(entity.getCreatedAt())
                .updatedAt(entity.getUpdatedAt())
                .build();
    }

    public FileJpaEntity toJpaEntity(FileItem domain) {
        if (domain == null)
            return null;
        return FileJpaEntity.builder()
                .id(uuidToBytes(domain.getId()))
                .name(domain.getName())
                .originalName(domain.getOriginalName())
                .folderId(uuidToBytes(domain.getFolderId()))
                .ownerId(domain.getOwnerId())
                .storagePath(domain.getStoragePath())
                .mimeType(domain.getMimeType())
                .extension(domain.getExtension())
                .sizeBytes(domain.getSizeBytes())
                .checksum(domain.getChecksum())
                .tags(domain.getTags())
                .fileType(domain.getFileType() != null ? domain.getFileType().name() : null)
                .deleted(domain.isDeleted())
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .build();
    }

    // ─── FileVersion mapping ────────────────────────────────────────

    public FileVersion toDomain(FileVersionJpaEntity entity) {
        if (entity == null)
            return null;
        return FileVersion.builder()
                .id(bytesToUuid(entity.getId()))
                .fileId(bytesToUuid(entity.getFileId()))
                .versionNumber(entity.getVersionNumber())
                .storagePath(entity.getStoragePath())
                .sizeBytes(entity.getSizeBytes())
                .checksum(entity.getChecksum())
                .createdBy(entity.getCreatedBy())
                .createdAt(entity.getCreatedAt())
                .build();
    }

    public FileVersionJpaEntity toJpaEntity(FileVersion domain) {
        if (domain == null)
            return null;
        return FileVersionJpaEntity.builder()
                .id(uuidToBytes(domain.getId()))
                .fileId(uuidToBytes(domain.getFileId()))
                .versionNumber(domain.getVersionNumber())
                .storagePath(domain.getStoragePath())
                .sizeBytes(domain.getSizeBytes())
                .checksum(domain.getChecksum())
                .createdBy(domain.getCreatedBy())
                .createdAt(domain.getCreatedAt())
                .build();
    }
}
