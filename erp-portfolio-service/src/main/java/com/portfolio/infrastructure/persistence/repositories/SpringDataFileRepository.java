package com.portfolio.infrastructure.persistence.repositories;

import com.portfolio.infrastructure.persistence.entities.FileJpaEntity;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SpringDataFileRepository extends JpaRepository<FileJpaEntity, byte[]> {

    @Query("SELECT f FROM FileJpaEntity f WHERE f.folderId = :folderId AND f.deleted = false")
    Page<FileJpaEntity> findByFolderIdAndNotDeleted(@Param("folderId") byte[] folderId, Pageable pageable);

    @Query("SELECT f FROM FileJpaEntity f WHERE f.folderId IS NULL AND f.ownerId = :ownerId AND f.deleted = false")
    Page<FileJpaEntity> findRootFilesByOwner(@Param("ownerId") String ownerId, Pageable pageable);

    @Query("SELECT f FROM FileJpaEntity f WHERE f.folderId = :folderId")
    List<FileJpaEntity> findByFolderIdAll(@Param("folderId") byte[] folderId);

    @Modifying
    @Query("UPDATE FileJpaEntity f SET f.deleted = true WHERE f.id = :id")
    void softDeleteById(@Param("id") byte[] id);

    @Query("SELECT SUM(f.sizeBytes) FROM FileJpaEntity f WHERE f.deleted = false")
    Long countTotalSizeBytes();
}
