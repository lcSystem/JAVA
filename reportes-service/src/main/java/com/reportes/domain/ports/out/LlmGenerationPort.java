package com.reportes.domain.ports.out;

import com.reportes.domain.model.ReportType;

public interface LlmGenerationPort {
    String generateHtml(ReportType type, String data);
}
