package com.portfolio.infrastructure.persistence.adapters;

import com.portfolio.domain.model.FileItem;
import com.portfolio.domain.model.FileVersion;
import com.portfolio.domain.ports.out.FileRepositoryPort;
import com.portfolio.infrastructure.persistence.entities.FileJpaEntity;
import com.portfolio.infrastructure.persistence.entities.FileVersionJpaEntity;
import com.portfolio.infrastructure.persistence.mappers.PortfolioMapper;
import com.portfolio.infrastructure.persistence.repositories.SpringDataFileRepository;
import com.portfolio.infrastructure.persistence.repositories.SpringDataFileVersionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class JpaFileRepositoryAdapter implements FileRepositoryPort {

    private final SpringDataFileRepository fileRepository;
    private final SpringDataFileVersionRepository versionRepository;
    private final PortfolioMapper mapper;

    @Override
    public FileItem save(FileItem fileItem) {
        FileJpaEntity entity = mapper.toJpaEntity(fileItem);
        FileJpaEntity saved = fileRepository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<FileItem> findById(UUID id) {
        return fileRepository.findById(mapper.uuidToBytes(id)).map(mapper::toDomain);
    }

    @Override
    public Page<FileItem> findByFolderIdAndNotDeleted(UUID folderId, Pageable pageable) {
        return fileRepository.findByFolderIdAndNotDeleted(mapper.uuidToBytes(folderId), pageable)
                .map(mapper::toDomain);
    }

    @Override
    public Page<FileItem> findRootFilesByOwner(String ownerId, Pageable pageable) {
        return fileRepository.findRootFilesByOwner(ownerId, pageable)
                .map(mapper::toDomain);
    }

    @Override
    public List<FileItem> findByFolderIdAll(UUID folderId) {
        return fileRepository.findByFolderIdAll(mapper.uuidToBytes(folderId))
                .stream().map(mapper::toDomain).collect(Collectors.toList());
    }

    @Override
    public void deleteById(UUID id) {
        fileRepository.deleteById(mapper.uuidToBytes(id));
    }

    @Override
    @Transactional
    public void softDeleteById(UUID id) {
        fileRepository.softDeleteById(mapper.uuidToBytes(id));
    }

    @Override
    public FileVersion saveVersion(FileVersion version) {
        FileVersionJpaEntity entity = mapper.toJpaEntity(version);
        FileVersionJpaEntity saved = versionRepository.save(entity);
        return mapper.toDomain(saved);
    }

    @Override
    public List<FileVersion> findVersionsByFileId(UUID fileId) {
        return versionRepository.findByFileId(mapper.uuidToBytes(fileId))
                .stream().map(mapper::toDomain).collect(Collectors.toList());
    }

    @Override
    public int getMaxVersionNumber(UUID fileId) {
        return versionRepository.getMaxVersionNumber(mapper.uuidToBytes(fileId));
    }
}
