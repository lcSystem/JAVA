package com.reportes.infrastructure.persistence.repository;

import com.reportes.infrastructure.persistence.entity.StoredReportQueryEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface StoredReportQueryJpaRepository extends JpaRepository<StoredReportQueryEntity, String> {
    List<StoredReportQueryEntity> findAllByOrderByCreatedAtDesc();
}
