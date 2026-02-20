package com.reportes.infrastructure.persistence.repository;

import com.reportes.infrastructure.persistence.entity.ReportRequestEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface JpaReportRequestRepository extends JpaRepository<ReportRequestEntity, UUID> {
    List<ReportRequestEntity> findByRequestedBy(String requestedBy);
}
