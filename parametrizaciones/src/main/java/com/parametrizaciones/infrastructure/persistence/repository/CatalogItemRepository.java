package com.parametrizaciones.infrastructure.persistence.repository;

import com.parametrizaciones.infrastructure.persistence.entities.CatalogItemJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CatalogItemRepository extends JpaRepository<CatalogItemJpaEntity, Long> {

    List<CatalogItemJpaEntity> findByCatalogCodeAndEnabledTrueOrderByOrderIndexAsc(String catalogCode);

    List<CatalogItemJpaEntity> findByParentIdAndEnabledTrueOrderByOrderIndexAsc(Long parentId);

    // Multi-tenant: items by catalog and company (includes global)
    @Query("SELECT i FROM CatalogItemJpaEntity i WHERE i.catalogCode = :catalogCode " +
            "AND i.enabled = true " +
            "AND (i.companyId = :companyId OR i.companyId IS NULL) " +
            "ORDER BY i.orderIndex ASC")
    List<CatalogItemJpaEntity> findByCatalogAndTenant(
            @Param("catalogCode") String catalogCode,
            @Param("companyId") Long companyId);

    // Fallback: find item by catalog + code, prioritizing company over global
    @Query("SELECT i FROM CatalogItemJpaEntity i WHERE i.catalogCode = :catalogCode " +
            "AND i.code = :itemCode AND i.enabled = true " +
            "AND (i.companyId = :companyId OR i.companyId IS NULL) " +
            "ORDER BY i.companyId DESC NULLS LAST")
    List<CatalogItemJpaEntity> findByCodeWithFallback(
            @Param("catalogCode") String catalogCode,
            @Param("itemCode") String itemCode,
            @Param("companyId") Long companyId);

    // All items for a catalog (global only, no tenant filter)
    List<CatalogItemJpaEntity> findByCatalogCodeAndCompanyIdIsNullAndEnabledTrueOrderByOrderIndexAsc(
            String catalogCode);

    Optional<CatalogItemJpaEntity> findByCatalogCodeAndCode(String catalogCode, String code);

    boolean existsByCatalogCodeAndCodeAndCompanyId(String catalogCode, String code, Long companyId);
}
