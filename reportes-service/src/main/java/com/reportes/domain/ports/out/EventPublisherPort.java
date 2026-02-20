package com.reportes.domain.ports.out;

import com.reportes.domain.model.ReportRequest;

public interface EventPublisherPort {
    void publishReportGenerated(ReportRequest reportRequest);

    void publishInternalProcessing(ReportRequest reportRequest); // For manual retries/distributed processing
}
