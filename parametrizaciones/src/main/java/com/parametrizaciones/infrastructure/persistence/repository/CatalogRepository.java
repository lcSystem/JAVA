package com.parametrizaciones.infrastructure.persistence.repository;

import com.parametrizaciones.infrastructure.persistence.entities.CatalogJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CatalogRepository extends JpaRepository<CatalogJpaEntity, Long> {
    Optional<CatalogJpaEntity> findByCode(String code);

    List<CatalogJpaEntity> findByEnabledTrue();

    boolean existsByCode(String code);
}
