package com.reportes.domain.model.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportExecutionAudit {
    private String id;
    private String userId;
    private String dataSourceId;
    private Integer recordCount;
    private String status;
    private String errorMessage;
    private LocalDateTime createdAt;
}
