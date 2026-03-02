package com.portfolio.infrastructure.persistence.adapters;

import com.portfolio.domain.model.Folder;
import com.portfolio.domain.ports.out.FolderRepositoryPort;
import com.portfolio.infrastructure.persistence.entities.FolderJpaEntity;
import com.portfolio.infrastructure.persistence.mappers.PortfolioMapper;
import com.portfolio.infrastructure.persistence.repositories.SpringDataFolderRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaFolderRepositoryAdapter implements FolderRepositoryPort {

    private final SpringDataFolderRepository repository;
    private final PortfolioMapper mapper;

    @Override
    public Folder save(Folder folder) {
        FolderJpaEntity entity = mapper.toJpaEntity(folder);
        FolderJpaEntity saved = repository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<Folder> findById(UUID id) {
        return repository.findById(mapper.uuidToBytes(id)).map(mapper::toDomain);
    }

    @Override
    public List<Folder> findByParentIdAndNotDeleted(UUID parentId, String ownerId) {
        return repository.findByParentIdAndNotDeleted(mapper.uuidToBytes(parentId), ownerId)
                .stream().map(mapper::toDomain).collect(Collectors.toList());
    }

    @Override
    public List<Folder> findRootFoldersByOwner(String ownerId) {
        return repository.findRootFoldersByOwner(ownerId)
                .stream().map(mapper::toDomain).collect(Collectors.toList());
    }

    @Override
    public List<Folder> findByPathStartingWith(String pathPrefix) {
        return repository.findByPathStartingWith(pathPrefix)
                .stream().map(mapper::toDomain).collect(Collectors.toList());
    }

    @Override
    public void deleteById(UUID id) {
        repository.deleteById(mapper.uuidToBytes(id));
    }

    @Override
    @Transactional
    public void softDeleteByIdAndDescendants(UUID id) {
        repository.softDeleteByIdAndDescendants(mapper.uuidToBytes(id));
    }

    @Override
    public boolean existsByNameAndParentId(String name, UUID parentId) {
        return repository.existsByNameAndParentId(name, mapper.uuidToBytes(parentId));
    }

    @Override
    @Transactional
    public void updatePathForDescendants(String oldPathPrefix, String newPathPrefix) {
        repository.updatePathForDescendants(oldPathPrefix, newPathPrefix);
    }
}
