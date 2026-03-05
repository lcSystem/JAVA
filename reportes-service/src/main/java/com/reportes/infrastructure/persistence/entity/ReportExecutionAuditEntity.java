package com.reportes.infrastructure.persistence.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "report_execution_audit")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportExecutionAuditEntity {
    @Id
    private String id;
    private String userId;
    private String dataSourceId;
    private Integer recordCount;
    private String status;
    private String errorMessage;
    private LocalDateTime createdAt;
}
