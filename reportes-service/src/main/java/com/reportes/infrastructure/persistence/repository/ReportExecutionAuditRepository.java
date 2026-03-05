package com.reportes.infrastructure.persistence.repository;

import com.reportes.infrastructure.persistence.entity.ReportExecutionAuditEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReportExecutionAuditRepository extends JpaRepository<ReportExecutionAuditEntity, String> {
}
