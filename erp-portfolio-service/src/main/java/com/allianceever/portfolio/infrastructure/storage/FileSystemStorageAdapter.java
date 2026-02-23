package com.allianceever.portfolio.infrastructure.storage;

import com.allianceever.portfolio.domain.exception.StorageException;
import com.allianceever.portfolio.domain.ports.out.StoragePort;
import lombok.extern.slf4j.Slf4j;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.*;

/**
 * FileSystem-based storage adapter.
 * Streams data directly to/from disk without loading fully into memory.
 * Ready to be replaced with MinIO/S3 adapter in the future.
 */
@Slf4j
public class FileSystemStorageAdapter implements StoragePort {

    private final Path basePath;

    public FileSystemStorageAdapter(String basePathStr) {
        this.basePath = Paths.get(basePathStr);
        try {
            Files.createDirectories(this.basePath);
            log.info("Storage initialized at: {}", this.basePath.toAbsolutePath());
        } catch (IOException e) {
            throw new StorageException("Failed to initialize storage directory: " + basePathStr, e);
        }
    }

    @Override
    public String store(InputStream inputStream, String storagePath) {
        try {
            Path targetPath = basePath.resolve(storagePath).normalize();

            // Security: ensure we're not writing outside base path
            if (!targetPath.startsWith(basePath)) {
                throw new StorageException("Invalid storage path: " + storagePath);
            }

            // Create parent directories
            Files.createDirectories(targetPath.getParent());

            // Stream directly to file (no memory buffering)
            Files.copy(inputStream, targetPath, StandardCopyOption.REPLACE_EXISTING);
            log.debug("Stored file at: {}", targetPath);

            return storagePath;
        } catch (IOException e) {
            throw new StorageException("Failed to store file: " + storagePath, e);
        }
    }

    @Override
    public InputStream retrieve(String storagePath) {
        try {
            Path targetPath = basePath.resolve(storagePath).normalize();

            if (!targetPath.startsWith(basePath)) {
                throw new StorageException("Invalid storage path: " + storagePath);
            }

            if (!Files.exists(targetPath)) {
                throw new StorageException("File not found in storage: " + storagePath);
            }

            return Files.newInputStream(targetPath);
        } catch (IOException e) {
            throw new StorageException("Failed to retrieve file: " + storagePath, e);
        }
    }

    @Override
    public void delete(String storagePath) {
        try {
            Path targetPath = basePath.resolve(storagePath).normalize();

            if (!targetPath.startsWith(basePath)) {
                throw new StorageException("Invalid storage path: " + storagePath);
            }

            if (Files.exists(targetPath)) {
                Files.delete(targetPath);
                log.debug("Deleted file: {}", targetPath);
            }
        } catch (IOException e) {
            throw new StorageException("Failed to delete file: " + storagePath, e);
        }
    }

    @Override
    public boolean exists(String storagePath) {
        Path targetPath = basePath.resolve(storagePath).normalize();
        return targetPath.startsWith(basePath) && Files.exists(targetPath);
    }
}
