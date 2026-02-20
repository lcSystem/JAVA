package com.reportes.domain.ports.in;

import com.reportes.domain.model.ReportRequest;
import com.reportes.domain.model.ReportType;
import java.util.UUID;

public interface RequestReportUseCase {
    UUID initiateReport(ReportType type, String parameters, String requestedBy);

    void processReport(UUID reportId);
}
