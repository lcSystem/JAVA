package com.reportes.domain.model.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DynamicReportHistory {
    private UUID id;
    private UUID templateId;
    private String templateName;
    private String microserviceId;
    private String entityId;
    private String format; // PDF, EXCEL
    private String createdBy;
    private LocalDateTime createdAt;
}
