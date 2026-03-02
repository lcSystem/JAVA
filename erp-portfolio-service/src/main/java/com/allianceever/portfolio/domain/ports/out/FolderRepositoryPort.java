package com.allianceever.portfolio.domain.ports.out;

import com.allianceever.portfolio.domain.model.Folder;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface FolderRepositoryPort {

    Folder save(Folder folder);

    Optional<Folder> findById(UUID id);

    List<Folder> findByParentIdAndNotDeleted(UUID parentId, String ownerId);

    List<Folder> findRootFoldersByOwner(String ownerId);

    List<Folder> findByPathStartingWith(String pathPrefix);

    void deleteById(UUID id);

    void softDeleteByIdAndDescendants(UUID id);

    boolean existsByNameAndParentId(String name, UUID parentId);

    void updatePathForDescendants(String oldPathPrefix, String newPathPrefix);
}
