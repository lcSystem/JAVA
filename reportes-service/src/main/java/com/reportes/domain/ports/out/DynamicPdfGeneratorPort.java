package com.reportes.domain.ports.out;

import com.reportes.domain.model.dynamic.ReportTemplate;
import java.util.Map;

public interface DynamicPdfGeneratorPort {
    byte[] generatePdf(ReportTemplate template, String rawDataJson, Map<String, Object> parameters);
}
