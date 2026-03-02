package com.portfolio.application.services;

import com.portfolio.domain.exception.FolderNotFoundException;
import com.portfolio.domain.exception.UnauthorizedAccessException;
import com.portfolio.domain.model.Folder;
import com.portfolio.domain.ports.in.FolderUseCase;
import com.portfolio.domain.ports.out.FileRepositoryPort;
import com.portfolio.domain.ports.out.FolderRepositoryPort;
import com.portfolio.domain.ports.out.StoragePort;
import com.portfolio.domain.model.FileItem;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
public class FolderUseCaseImpl implements FolderUseCase {

    private final FolderRepositoryPort folderRepository;
    private final FileRepositoryPort fileRepository;
    private final StoragePort storagePort;

    @Override
    public Folder createFolder(String name, UUID parentId, String ownerId) {
        String path;

        if (parentId != null) {
            Folder parent = folderRepository.findById(parentId)
                    .orElseThrow(() -> new FolderNotFoundException("Parent folder not found: " + parentId));
            validateOwnership(parent, ownerId);
            path = parent.getPath() + "/" + name;
        } else {
            path = "/" + name;
        }

        if (folderRepository.existsByNameAndParentId(name, parentId)) {
            throw new IllegalArgumentException("A folder with name '" + name + "' already exists in this location");
        }

        Folder folder = Folder.builder()
                .id(UUID.randomUUID())
                .name(name)
                .parentId(parentId)
                .ownerId(ownerId)
                .path(path)
                .deleted(false)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        return folderRepository.save(folder);
    }

    @Override
    public Folder renameFolder(UUID folderId, String newName, String ownerId) {
        Folder folder = getFolderOrThrow(folderId);
        validateOwnership(folder, ownerId);

        String oldPath = folder.getPath();
        String parentPath = oldPath.substring(0, oldPath.lastIndexOf('/'));
        String newPath = parentPath + "/" + newName;

        // Update path for all descendants
        folderRepository.updatePathForDescendants(oldPath, newPath);

        folder.setName(newName);
        folder.setPath(newPath);
        folder.setUpdatedAt(LocalDateTime.now());

        return folderRepository.save(folder);
    }

    @Override
    public void softDeleteFolder(UUID folderId, String ownerId) {
        Folder folder = getFolderOrThrow(folderId);
        validateOwnership(folder, ownerId);

        // Soft delete the folder and all descendants
        folderRepository.softDeleteByIdAndDescendants(folderId);
        log.info("Soft deleted folder {} and its descendants", folderId);
    }

    @Override
    public void hardDeleteFolder(UUID folderId, String ownerId) {
        Folder folder = getFolderOrThrow(folderId);
        validateOwnership(folder, ownerId);

        // Delete all files in this folder and descendants from storage
        List<Folder> descendants = folderRepository.findByPathStartingWith(folder.getPath());
        for (Folder desc : descendants) {
            List<FileItem> files = fileRepository.findByFolderIdAll(desc.getId());
            for (FileItem file : files) {
                storagePort.delete(file.getStoragePath());
                fileRepository.deleteById(file.getId());
            }
            folderRepository.deleteById(desc.getId());
        }

        // Delete files in this folder
        List<FileItem> files = fileRepository.findByFolderIdAll(folderId);
        for (FileItem file : files) {
            storagePort.delete(file.getStoragePath());
            fileRepository.deleteById(file.getId());
        }

        folderRepository.deleteById(folderId);
        log.info("Hard deleted folder {} with all contents", folderId);
    }

    @Override
    public Folder moveFolder(UUID folderId, UUID newParentId, String ownerId) {
        Folder folder = getFolderOrThrow(folderId);
        validateOwnership(folder, ownerId);

        String oldPath = folder.getPath();
        String newPath;

        if (newParentId != null) {
            Folder newParent = getFolderOrThrow(newParentId);
            validateOwnership(newParent, ownerId);

            // Prevent moving folder into its own descendant
            if (newParent.getPath().startsWith(oldPath + "/")) {
                throw new IllegalArgumentException("Cannot move a folder into its own descendant");
            }
            newPath = newParent.getPath() + "/" + folder.getName();
        } else {
            newPath = "/" + folder.getName();
        }

        // Update all descendants' paths in a single operation
        folderRepository.updatePathForDescendants(oldPath, newPath);

        folder.setParentId(newParentId);
        folder.setPath(newPath);
        folder.setUpdatedAt(LocalDateTime.now());

        return folderRepository.save(folder);
    }

    @Override
    public List<Folder> listChildren(UUID parentId, String ownerId) {
        return folderRepository.findByParentIdAndNotDeleted(parentId, ownerId);
    }

    @Override
    public List<Folder> getRootFolders(String ownerId) {
        return folderRepository.findRootFoldersByOwner(ownerId);
    }

    @Override
    public List<Folder> getBreadcrumb(UUID folderId) {
        List<Folder> breadcrumb = new ArrayList<>();
        Folder current = getFolderOrThrow(folderId);

        breadcrumb.add(current);
        while (current.getParentId() != null) {
            current = getFolderOrThrow(current.getParentId());
            breadcrumb.add(current);
        }

        Collections.reverse(breadcrumb);
        return breadcrumb;
    }

    @Override
    public Folder getFolderById(UUID folderId, String ownerId) {
        Folder folder = getFolderOrThrow(folderId);
        validateOwnership(folder, ownerId);
        return folder;
    }

    private Folder getFolderOrThrow(UUID folderId) {
        return folderRepository.findById(folderId)
                .orElseThrow(() -> new FolderNotFoundException("Folder not found: " + folderId));
    }

    private void validateOwnership(Folder folder, String ownerId) {
        if (!folder.getOwnerId().equals(ownerId)) {
            throw new UnauthorizedAccessException("You don't have access to this folder");
        }
    }
}
