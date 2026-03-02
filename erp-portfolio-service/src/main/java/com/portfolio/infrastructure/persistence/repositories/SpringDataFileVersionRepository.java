package com.portfolio.infrastructure.persistence.repositories;

import com.portfolio.infrastructure.persistence.entities.FileVersionJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SpringDataFileVersionRepository extends JpaRepository<FileVersionJpaEntity, byte[]> {

    @Query("SELECT v FROM FileVersionJpaEntity v WHERE v.fileId = :fileId ORDER BY v.versionNumber DESC")
    List<FileVersionJpaEntity> findByFileId(@Param("fileId") byte[] fileId);

    @Query("SELECT COALESCE(MAX(v.versionNumber), 0) FROM FileVersionJpaEntity v WHERE v.fileId = :fileId")
    int getMaxVersionNumber(@Param("fileId") byte[] fileId);
}
