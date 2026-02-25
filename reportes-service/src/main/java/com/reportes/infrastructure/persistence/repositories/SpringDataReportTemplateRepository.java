package com.reportes.infrastructure.persistence.repositories;

import com.reportes.infrastructure.persistence.entities.ReportTemplateEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface SpringDataReportTemplateRepository extends JpaRepository<ReportTemplateEntity, UUID> {
}
