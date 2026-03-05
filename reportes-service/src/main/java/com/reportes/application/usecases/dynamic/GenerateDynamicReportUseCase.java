package com.reportes.application.usecases.dynamic;

import com.reportes.domain.model.dynamic.ReportTemplate;
import java.util.Map;
import java.util.UUID;

public interface GenerateDynamicReportUseCase {
    /**
     * @param templateId   The UUID of the template to use
     * @param dataSourceId The abstracted data source identifier
     * @param filters      Dynamic filters passing from frontend
     * @param parameters   Any dynamic parameters applied for title, subtitles, etc.
     * @param format       "PDF" | "EXCEL"
     * @param authToken    The user's JWT
     * @param userRoles    The user's roles
     * @param requestedBy  The requested by username
     * @return a byte array representing the file content
     */
    byte[] generateReport(UUID templateId, String dataSourceId, Map<String, Object> filters,
            Map<String, Object> parameters, String format, String authToken, java.util.Set<String> userRoles,
            String requestedBy);
}
