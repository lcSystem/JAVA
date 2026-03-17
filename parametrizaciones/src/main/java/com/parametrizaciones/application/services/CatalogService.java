package com.parametrizaciones.application.services;

import com.parametrizaciones.infrastructure.persistence.entities.CatalogItemJpaEntity;
import com.parametrizaciones.infrastructure.persistence.entities.CatalogJpaEntity;
import com.parametrizaciones.infrastructure.persistence.repository.CatalogItemRepository;
import com.parametrizaciones.infrastructure.persistence.repository.CatalogRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@RequiredArgsConstructor
public class CatalogService {

    private final CatalogRepository catalogRepository;
    private final CatalogItemRepository catalogItemRepository;

    // ===================== CATALOG CRUD =====================

    @Cacheable(value = "catalogs", key = "'all'")
    public List<CatalogJpaEntity> getAllCatalogs() {
        return catalogRepository.findByEnabledTrue();
    }

    public Optional<CatalogJpaEntity> getCatalogByCode(String code) {
        return catalogRepository.findByCode(code);
    }

    @CacheEvict(value = "catalogs", allEntries = true)
    @Transactional
    public CatalogJpaEntity createCatalog(CatalogJpaEntity entity) {
        if (catalogRepository.existsByCode(entity.getCode())) {
            throw new IllegalArgumentException("El catálogo con código '" + entity.getCode() + "' ya existe.");
        }
        return catalogRepository.save(entity);
    }

    @CacheEvict(value = "catalogs", allEntries = true)
    @Transactional
    public CatalogJpaEntity updateCatalog(Long id, CatalogJpaEntity update) {
        CatalogJpaEntity existing = catalogRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Catálogo no encontrado con id: " + id));
        existing.setName(update.getName());
        existing.setDescription(update.getDescription());
        existing.setType(update.getType());
        existing.setEnabled(update.isEnabled());
        existing.setUpdatedBy(update.getUpdatedBy());
        return catalogRepository.save(existing);
    }

    // ===================== CATALOG ITEM CRUD =====================

    @Cacheable(value = "catalogItems", key = "#catalogCode")
    public List<CatalogItemJpaEntity> getItemsByCatalog(String catalogCode) {
        return catalogItemRepository.findByCatalogCodeAndEnabledTrueOrderByOrderIndexAsc(catalogCode);
    }

    /**
     * Multi-tenant fallback: returns company-specific items + global items.
     */
    @Cacheable(value = "catalogItems", key = "#catalogCode + '_' + #companyId")
    public List<CatalogItemJpaEntity> getItemsByCatalogAndTenant(String catalogCode, Long companyId) {
        if (companyId == null) {
            return catalogItemRepository
                    .findByCatalogCodeAndCompanyIdIsNullAndEnabledTrueOrderByOrderIndexAsc(catalogCode);
        }
        return catalogItemRepository.findByCatalogAndTenant(catalogCode, companyId);
    }

    /**
     * Fallback: find a specific item by code, prioritizing company over global.
     */
    public Optional<CatalogItemJpaEntity> getItemByCodeWithFallback(String catalogCode, String itemCode,
            Long companyId) {
        if (companyId == null) {
            return catalogItemRepository.findByCatalogCodeAndCode(catalogCode, itemCode);
        }
        List<CatalogItemJpaEntity> results = catalogItemRepository.findByCodeWithFallback(catalogCode, itemCode,
                companyId);
        return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
    }

    public List<CatalogItemJpaEntity> getChildren(Long parentId) {
        return catalogItemRepository.findByParentIdAndEnabledTrueOrderByOrderIndexAsc(parentId);
    }

    @CacheEvict(value = "catalogItems", allEntries = true)
    @Transactional
    public CatalogItemJpaEntity createItem(CatalogItemJpaEntity entity) {
        // Validate catalog exists
        if (!catalogRepository.existsByCode(entity.getCatalogCode())) {
            throw new IllegalArgumentException("El catálogo '" + entity.getCatalogCode() + "' no existe.");
        }

        // Calculate path and level
        computeHierarchy(entity);

        // Prevent cycle: parentId cannot be the item itself (for updates)
        if (entity.getId() != null && entity.getId().equals(entity.getParentId())) {
            throw new IllegalArgumentException("Un ítem no puede ser su propio padre.");
        }

        log.info("Creating catalog item: catalog={}, code={}, company={}", entity.getCatalogCode(), entity.getCode(),
                entity.getCompanyId());
        return catalogItemRepository.save(entity);
    }

    @CacheEvict(value = "catalogItems", allEntries = true)
    @Transactional
    public CatalogItemJpaEntity updateItem(Long id, CatalogItemJpaEntity update) {
        CatalogItemJpaEntity existing = catalogItemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ítem de catálogo no encontrado con id: " + id));

        existing.setName(update.getName());
        existing.setDescription(update.getDescription());
        existing.setOrderIndex(update.getOrderIndex());
        existing.setExtraData(update.getExtraData());
        existing.setEnabled(update.isEnabled());
        existing.setUpdatedBy(update.getUpdatedBy());

        // If parent changed, recalculate hierarchy
        if (!java.util.Objects.equals(existing.getParentId(), update.getParentId())) {
            if (id.equals(update.getParentId())) {
                throw new IllegalArgumentException("Un ítem no puede ser su propio padre.");
            }
            existing.setParentId(update.getParentId());
            computeHierarchy(existing);
        }

        return catalogItemRepository.save(existing);
    }

    /**
     * Soft delete: marks item as deleted without removing from DB.
     */
    @CacheEvict(value = "catalogItems", allEntries = true)
    @Transactional
    public void softDeleteItem(Long id) {
        CatalogItemJpaEntity entity = catalogItemRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Ítem no encontrado con id: " + id));
        entity.setDeleted(true);
        entity.setEnabled(false);
        catalogItemRepository.save(entity);
        log.info("Soft-deleted catalog item: id={}, code={}", id, entity.getCode());
    }

    // ===================== HIERARCHY HELPERS =====================

    /**
     * Computes `path` and `level` based on parentId.
     * Path format: /rootId/parentId/currentId/
     */
    private void computeHierarchy(CatalogItemJpaEntity entity) {
        if (entity.getParentId() == null) {
            entity.setPath("/");
            entity.setLevel(0);
        } else {
            Optional<CatalogItemJpaEntity> parentOpt = catalogItemRepository.findById(entity.getParentId());
            if (parentOpt.isPresent()) {
                CatalogItemJpaEntity parent = parentOpt.get();
                String parentPath = parent.getPath() != null ? parent.getPath() : "/";
                entity.setPath(parentPath + parent.getId() + "/");
                entity.setLevel((parent.getLevel() != null ? parent.getLevel() : 0) + 1);
            } else {
                entity.setPath("/");
                entity.setLevel(0);
            }
        }
    }
}
