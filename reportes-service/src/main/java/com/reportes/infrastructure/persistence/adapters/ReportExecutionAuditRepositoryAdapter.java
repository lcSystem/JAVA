package com.reportes.infrastructure.persistence.adapters;

import com.reportes.domain.model.dynamic.ReportExecutionAudit;
import com.reportes.domain.ports.out.ReportExecutionAuditRepositoryPort;
import com.reportes.infrastructure.persistence.entity.ReportExecutionAuditEntity;
import com.reportes.infrastructure.persistence.repository.ReportExecutionAuditRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ReportExecutionAuditRepositoryAdapter implements ReportExecutionAuditRepositoryPort {

    private final ReportExecutionAuditRepository repository;

    @Override
    public ReportExecutionAudit save(ReportExecutionAudit audit) {
        ReportExecutionAuditEntity entity = ReportExecutionAuditEntity.builder()
                .id(audit.getId())
                .userId(audit.getUserId())
                .dataSourceId(audit.getDataSourceId())
                .recordCount(audit.getRecordCount())
                .status(audit.getStatus())
                .errorMessage(audit.getErrorMessage())
                .createdAt(audit.getCreatedAt())
                .build();

        entity = repository.save(entity);

        return ReportExecutionAudit.builder()
                .id(entity.getId())
                .userId(entity.getUserId())
                .dataSourceId(entity.getDataSourceId())
                .recordCount(entity.getRecordCount())
                .status(entity.getStatus())
                .errorMessage(entity.getErrorMessage())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
