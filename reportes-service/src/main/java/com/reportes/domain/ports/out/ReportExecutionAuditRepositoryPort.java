package com.reportes.domain.ports.out;

import com.reportes.domain.model.dynamic.ReportExecutionAudit;

public interface ReportExecutionAuditRepositoryPort {
    ReportExecutionAudit save(ReportExecutionAudit audit);
}
