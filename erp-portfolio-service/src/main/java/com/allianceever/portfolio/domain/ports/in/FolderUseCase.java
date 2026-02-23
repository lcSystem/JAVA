package com.allianceever.portfolio.domain.ports.in;

import com.allianceever.portfolio.domain.model.Folder;

import java.util.List;
import java.util.UUID;

public interface FolderUseCase {

    Folder createFolder(String name, UUID parentId, String ownerId);

    Folder renameFolder(UUID folderId, String newName, String ownerId);

    void softDeleteFolder(UUID folderId, String ownerId);

    void hardDeleteFolder(UUID folderId, String ownerId);

    Folder moveFolder(UUID folderId, UUID newParentId, String ownerId);

    List<Folder> listChildren(UUID parentId, String ownerId);

    List<Folder> getRootFolders(String ownerId);

    List<Folder> getBreadcrumb(UUID folderId);

    Folder getFolderById(UUID folderId, String ownerId);
}
