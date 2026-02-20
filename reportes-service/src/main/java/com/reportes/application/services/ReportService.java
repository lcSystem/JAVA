package com.reportes.application.services;

import com.reportes.domain.exception.ReportNotFoundException;
import com.reportes.domain.model.ReportRequest;
import com.reportes.domain.model.ReportStatus;
import com.reportes.domain.model.ReportType;
import com.reportes.domain.ports.in.GetReportStatusUseCase;
import com.reportes.domain.ports.in.RequestReportUseCase;
import com.reportes.domain.ports.out.EventPublisherPort;
import com.reportes.domain.ports.out.ReportRepositoryPort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReportService implements RequestReportUseCase, GetReportStatusUseCase {

    private final ReportRepositoryPort repositoryPort;
    private final EventPublisherPort eventPublisherPort;

    @Override
    @Transactional
    public UUID initiateReport(ReportType type, String parameters, String requestedBy) {
        ReportRequest request = ReportRequest.builder()
                .id(UUID.randomUUID())
                .reportType(type)
                .parameters(parameters)
                .requestedBy(requestedBy)
                .status(ReportStatus.PENDING)
                .createdAt(LocalDateTime.now())
                .retryCount(0)
                .build();

        repositoryPort.save(request);
        log.info("Initiated report {} for user {}", request.getId(), requestedBy);

        try {
            eventPublisherPort.publishInternalProcessing(request);
        } catch (Exception e) {
            log.warn("Failed to publish internal processing event for report {}. RabbitMQ might be down: {}",
                    request.getId(), e.getMessage());
        }
        return request.getId();
    }

    @Override
    public void processReport(UUID reportId) {
        // This is called by the internal consumer or manually
        ReportRequest request = repositoryPort.findById(reportId)
                .orElseThrow(() -> new ReportNotFoundException("Report not found: " + reportId));

        log.info("Starting processing for report {}", reportId);
        request.startProcessing();
        repositoryPort.save(request);
    }

    @Override
    public ReportRequest getReport(UUID id) {
        return repositoryPort.findById(id)
                .orElseThrow(() -> new ReportNotFoundException("Report not found: " + id));
    }

    @Override
    public List<ReportRequest> getReportsByUser(String username) {
        return repositoryPort.findByRequestedBy(username);
    }
}
