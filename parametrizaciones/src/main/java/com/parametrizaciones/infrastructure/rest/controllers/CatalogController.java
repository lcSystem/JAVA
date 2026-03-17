package com.parametrizaciones.infrastructure.rest.controllers;

import com.parametrizaciones.application.services.CatalogService;
import com.parametrizaciones.domain.model.Catalog.CatalogType;
import com.parametrizaciones.infrastructure.persistence.entities.CatalogItemJpaEntity;
import com.parametrizaciones.infrastructure.persistence.entities.CatalogJpaEntity;
import com.parametrizaciones.infrastructure.rest.dto.CatalogDto;
import com.parametrizaciones.infrastructure.rest.dto.CatalogItemDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/catalogs")
@RequiredArgsConstructor
public class CatalogController {

    private final CatalogService catalogService;

    // ===================== CATALOG ENDPOINTS =====================

    @GetMapping
    public ResponseEntity<List<CatalogDto>> getAllCatalogs() {
        List<CatalogDto> catalogs = catalogService.getAllCatalogs().stream()
                .map(this::toCatalogDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(catalogs);
    }

    @GetMapping("/{code}")
    public ResponseEntity<CatalogDto> getCatalogByCode(@PathVariable String code) {
        return catalogService.getCatalogByCode(code)
                .map(c -> ResponseEntity.ok(toCatalogDto(c)))
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<CatalogDto> createCatalog(@RequestBody CatalogDto dto) {
        CatalogJpaEntity entity = toCatalogEntity(dto);
        entity.setCreatedBy(getCurrentUser());
        CatalogJpaEntity saved = catalogService.createCatalog(entity);
        return ResponseEntity.status(HttpStatus.CREATED).body(toCatalogDto(saved));
    }

    @PutMapping("/{id}")
    public ResponseEntity<CatalogDto> updateCatalog(@PathVariable Long id, @RequestBody CatalogDto dto) {
        CatalogJpaEntity entity = toCatalogEntity(dto);
        entity.setUpdatedBy(getCurrentUser());
        CatalogJpaEntity updated = catalogService.updateCatalog(id, entity);
        return ResponseEntity.ok(toCatalogDto(updated));
    }

    // ===================== CATALOG ITEM ENDPOINTS =====================

    @GetMapping("/{code}/items")
    public ResponseEntity<List<CatalogItemDto>> getItemsByCatalog(
            @PathVariable String code,
            @RequestParam(required = false) Long companyId) {
        List<CatalogItemJpaEntity> items;
        if (companyId != null) {
            items = catalogService.getItemsByCatalogAndTenant(code, companyId);
        } else {
            items = catalogService.getItemsByCatalog(code);
        }
        return ResponseEntity.ok(items.stream().map(this::toItemDto).collect(Collectors.toList()));
    }

    @GetMapping("/{code}/items/{itemCode}")
    public ResponseEntity<CatalogItemDto> getItemByCode(
            @PathVariable String code,
            @PathVariable String itemCode,
            @RequestParam(required = false) Long companyId) {
        return catalogService.getItemByCodeWithFallback(code, itemCode, companyId)
                .map(i -> ResponseEntity.ok(toItemDto(i)))
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/items/{id}/children")
    public ResponseEntity<List<CatalogItemDto>> getChildren(@PathVariable Long id) {
        List<CatalogItemDto> children = catalogService.getChildren(id).stream()
                .map(this::toItemDto)
                .collect(Collectors.toList());
        return ResponseEntity.ok(children);
    }

    @PostMapping("/{code}/items")
    public ResponseEntity<CatalogItemDto> createItem(@PathVariable String code, @RequestBody CatalogItemDto dto) {
        CatalogItemJpaEntity entity = toItemEntity(dto);
        entity.setCatalogCode(code);
        entity.setCreatedBy(getCurrentUser());
        CatalogItemJpaEntity saved = catalogService.createItem(entity);
        return ResponseEntity.status(HttpStatus.CREATED).body(toItemDto(saved));
    }

    @PutMapping("/items/{id}")
    public ResponseEntity<CatalogItemDto> updateItem(@PathVariable Long id, @RequestBody CatalogItemDto dto) {
        CatalogItemJpaEntity entity = toItemEntity(dto);
        entity.setUpdatedBy(getCurrentUser());
        CatalogItemJpaEntity updated = catalogService.updateItem(id, entity);
        return ResponseEntity.ok(toItemDto(updated));
    }

    @DeleteMapping("/items/{id}")
    public ResponseEntity<Void> softDeleteItem(@PathVariable Long id) {
        catalogService.softDeleteItem(id);
        return ResponseEntity.noContent().build();
    }

    // ===================== HELPERS =====================

    private String getCurrentUser() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        return auth != null ? auth.getName() : "system";
    }

    private CatalogDto toCatalogDto(CatalogJpaEntity e) {
        return CatalogDto.builder()
                .id(e.getId())
                .code(e.getCode())
                .name(e.getName())
                .description(e.getDescription())
                .type(e.getType() != null ? e.getType().name() : null)
                .enabled(e.isEnabled())
                .build();
    }

    private CatalogJpaEntity toCatalogEntity(CatalogDto dto) {
        return CatalogJpaEntity.builder()
                .code(dto.getCode())
                .name(dto.getName())
                .description(dto.getDescription())
                .type(dto.getType() != null ? CatalogType.valueOf(dto.getType()) : CatalogType.DYNAMIC)
                .enabled(dto.isEnabled())
                .build();
    }

    private CatalogItemDto toItemDto(CatalogItemJpaEntity e) {
        return CatalogItemDto.builder()
                .id(e.getId())
                .catalogCode(e.getCatalogCode())
                .parentId(e.getParentId())
                .companyId(e.getCompanyId())
                .code(e.getCode())
                .name(e.getName())
                .description(e.getDescription())
                .orderIndex(e.getOrderIndex())
                .path(e.getPath())
                .level(e.getLevel())
                .extraData(e.getExtraData())
                .enabled(e.isEnabled())
                .createdAt(e.getCreatedAt())
                .createdBy(e.getCreatedBy())
                .updatedAt(e.getUpdatedAt())
                .updatedBy(e.getUpdatedBy())
                .build();
    }

    private CatalogItemJpaEntity toItemEntity(CatalogItemDto dto) {
        return CatalogItemJpaEntity.builder()
                .catalogCode(dto.getCatalogCode())
                .parentId(dto.getParentId())
                .companyId(dto.getCompanyId())
                .code(dto.getCode())
                .name(dto.getName())
                .description(dto.getDescription())
                .orderIndex(dto.getOrderIndex() != null ? dto.getOrderIndex() : 0)
                .extraData(dto.getExtraData())
                .enabled(dto.isEnabled())
                .build();
    }
}
