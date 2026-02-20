package com.reportes.application.strategies;

import com.reportes.domain.model.ReportRequest;
import com.reportes.domain.model.ReportType;

public interface ReportStrategy {
    boolean supports(ReportType type);

    String buildPrompt(ReportRequest request);
}
