package com.allianceever.parametrizaciones.infrastructure.persistence.repositories;

import com.allianceever.parametrizaciones.infrastructure.persistence.entities.ParameterCategoryJpaEntity;
import com.allianceever.parametrizaciones.infrastructure.persistence.entities.ParameterJpaEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface SpringDataParameterRepository extends JpaRepository<ParameterJpaEntity, Long> {
    Optional<ParameterJpaEntity> findByServiceNameAndKey(String serviceName, String key);

    List<ParameterJpaEntity> findByServiceName(String serviceName);
}

interface SpringDataParameterCategoryRepository extends JpaRepository<ParameterCategoryJpaEntity, Long> {
    Optional<ParameterCategoryJpaEntity> findByName(String name);
}
