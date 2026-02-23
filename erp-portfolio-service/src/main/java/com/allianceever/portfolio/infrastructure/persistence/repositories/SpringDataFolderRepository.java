package com.allianceever.portfolio.infrastructure.persistence.repositories;

import com.allianceever.portfolio.infrastructure.persistence.entities.FolderJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface SpringDataFolderRepository extends JpaRepository<FolderJpaEntity, byte[]> {

    @Query("SELECT f FROM FolderJpaEntity f WHERE f.parentId = :parentId AND f.deleted = false")
    List<FolderJpaEntity> findByParentIdAndNotDeleted(@Param("parentId") byte[] parentId);

    @Query("SELECT f FROM FolderJpaEntity f WHERE f.parentId IS NULL AND f.ownerId = :ownerId AND f.deleted = false")
    List<FolderJpaEntity> findRootFoldersByOwner(@Param("ownerId") String ownerId);

    @Query("SELECT f FROM FolderJpaEntity f WHERE f.path LIKE CONCAT(:pathPrefix, '%')")
    List<FolderJpaEntity> findByPathStartingWith(@Param("pathPrefix") String pathPrefix);

    @Modifying
    @Query("UPDATE FolderJpaEntity f SET f.deleted = true WHERE f.id = :id OR f.path LIKE CONCAT((SELECT f2.path FROM FolderJpaEntity f2 WHERE f2.id = :id), '/%')")
    void softDeleteByIdAndDescendants(@Param("id") byte[] id);

    @Query("SELECT CASE WHEN COUNT(f) > 0 THEN true ELSE false END FROM FolderJpaEntity f WHERE f.name = :name AND f.parentId = :parentId AND f.deleted = false")
    boolean existsByNameAndParentId(@Param("name") String name, @Param("parentId") byte[] parentId);

    @Modifying
    @Query(value = "UPDATE portfolio_folder SET path = REPLACE(path, :oldPrefix, :newPrefix) WHERE path LIKE CONCAT(:oldPrefix, '%')", nativeQuery = true)
    void updatePathForDescendants(@Param("oldPrefix") String oldPrefix, @Param("newPrefix") String newPrefix);
}
