package com.reportes.infrastructure.persistence.repository;

import com.reportes.infrastructure.persistence.entity.DynamicReportHistoryEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface SpringDataDynamicReportHistoryRepository extends JpaRepository<DynamicReportHistoryEntity, UUID> {
    List<DynamicReportHistoryEntity> findAllByOrderByCreatedAtDesc();
}
