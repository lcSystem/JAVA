package com.reportes.domain.ports.out;

import com.reportes.domain.model.dynamic.ReportTemplate;
import java.util.List;
import java.util.Map;

public interface DynamicExcelGeneratorPort {
    byte[] generateExcel(ReportTemplate template, List<Map<String, Object>> data, Map<String, Object> parameters);
}
