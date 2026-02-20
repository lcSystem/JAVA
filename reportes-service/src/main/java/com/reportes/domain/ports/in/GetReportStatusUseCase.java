package com.reportes.domain.ports.in;

import com.reportes.domain.model.ReportRequest;
import java.util.List;
import java.util.UUID;

public interface GetReportStatusUseCase {
    ReportRequest getReport(UUID id);

    List<ReportRequest> getReportsByUser(String username);
}
