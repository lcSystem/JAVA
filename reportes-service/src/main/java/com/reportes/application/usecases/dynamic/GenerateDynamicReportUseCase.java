package com.reportes.application.usecases.dynamic;

import com.reportes.domain.model.dynamic.ReportTemplate;
import java.util.Map;
import java.util.UUID;

public interface GenerateDynamicReportUseCase {
    /**
     * @param templateId     The UUID of the template to use
     * @param rawData        The generic JSON-like data provided by the calling
     *                       microservice
     * @param parameters     Any dynamic filters/parameters applied for title,
     *                       subtitles, etc.
     * @param format         "PDF" | "EXCEL"
     * @param microserviceId Origin microservice
     * @param entityId       Origin entity dataset
     * @param requestedBy    Username requesting the report
     * @return a byte array representing the file content
     */
    byte[] generateReport(UUID templateId, String rawData, Map<String, Object> parameters, String format,
            String microserviceId, String entityId, String requestedBy);
}
