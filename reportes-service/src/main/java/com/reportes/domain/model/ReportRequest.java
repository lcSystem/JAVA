package com.reportes.domain.model;

import lombok.Builder;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
@Builder
public class ReportRequest {
    private UUID id;
    private ReportType reportType;
    private String parameters; // JSON format
    private String requestedBy;
    private ReportStatus status;
    private String fileUrl;
    private String errorMessage;
    private String lastError;
    private int retryCount;
    private Long version;
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;

    public void startProcessing() {
        this.status = ReportStatus.PROCESSING;
    }

    public void complete(String fileUrl) {
        this.status = ReportStatus.COMPLETED;
        this.fileUrl = fileUrl;
        this.completedAt = LocalDateTime.now();
    }

    public void fail(String error) {
        this.status = ReportStatus.FAILED;
        this.errorMessage = error;
    }

    public boolean canRetry() {
        return this.retryCount < 3;
    }

    public void markForRetry(String error) {
        this.status = ReportStatus.RETRYING;
        this.lastError = error;
        this.retryCount++;
    }
}
