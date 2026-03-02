package com.portfolio.domain.ports.out;

import java.io.InputStream;

/**
 * Storage abstraction layer. Current implementation uses local filesystem.
 * Can be replaced with MinIO/S3 adapter in the future.
 */
public interface StoragePort {

    /**
     * Stores a file from an input stream to the given path.
     *
     * @param inputStream the file content stream
     * @param storagePath the relative storage path
     * @return the actual storage path used
     */
    String store(InputStream inputStream, String storagePath);

    /**
     * Retrieves a file as a streaming InputStream.
     *
     * @param storagePath the relative storage path
     * @return input stream of the file content
     */
    InputStream retrieve(String storagePath);

    /**
     * Deletes a file from storage.
     *
     * @param storagePath the relative storage path
     */
    void delete(String storagePath);

    /**
     * Checks if a file exists at the given path.
     *
     * @param storagePath the relative storage path
     * @return true if the file exists
     */
    boolean exists(String storagePath);

    /**
     * Moves a file from source to target path.
     *
     * @param sourcePath the current relative storage path
     * @param targetPath the new relative storage path
     */
    void move(String sourcePath, String targetPath);
}
