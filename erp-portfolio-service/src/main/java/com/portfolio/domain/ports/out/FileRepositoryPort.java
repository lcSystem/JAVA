package com.portfolio.domain.ports.out;

import com.portfolio.domain.model.FileItem;
import com.portfolio.domain.model.FileVersion;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface FileRepositoryPort {

    FileItem save(FileItem fileItem);

    Optional<FileItem> findById(UUID id);

    Page<FileItem> findByFolderIdAndNotDeleted(UUID folderId, Pageable pageable);

    Page<FileItem> findRootFilesByOwner(String ownerId, Pageable pageable);

    List<FileItem> findByFolderIdAll(UUID folderId);

    void deleteById(UUID id);

    void softDeleteById(UUID id);

    FileVersion saveVersion(FileVersion version);

    List<FileVersion> findVersionsByFileId(UUID fileId);

    int getMaxVersionNumber(UUID fileId);
}
