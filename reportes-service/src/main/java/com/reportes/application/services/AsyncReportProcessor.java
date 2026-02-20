package com.reportes.application.services;

import com.reportes.application.strategies.ReportStrategy;
import com.reportes.domain.model.ReportRequest;
import com.reportes.domain.ports.out.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class AsyncReportProcessor {

    private final ReportRepositoryPort repositoryPort;
    private final LlmGenerationPort llmGenerationPort;
    private final PdfGenerationPort pdfGenerationPort;
    private final ReportStoragePort storagePort;
    private final EventPublisherPort eventPublisherPort;
    private final List<ReportStrategy> strategies;

    @Async("reportTaskExecutor")
    public void processAsync(UUID reportId) {
        ReportRequest request = repositoryPort.findById(reportId).orElse(null);
        if (request == null)
            return;

        try {
            log.info("Processing report {} type {}", reportId, request.getReportType());

            ReportStrategy strategy = strategies.stream()
                    .filter(s -> s.supports(request.getReportType()))
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("No strategy found for " + request.getReportType()));

            String prompt = strategy.buildPrompt(request);

            // LLM Generation
            String html = llmGenerationPort.generateHtml(request.getReportType(), prompt);

            // PDF Generation
            byte[] pdf = pdfGenerationPort.generatePdf(html);

            // Storage
            String fileName = "report_" + reportId + ".pdf";
            String url = storagePort.store(pdf, fileName);

            // Update to COMPLETED
            request.complete(url);
            repositoryPort.save(request);

            // Notify
            eventPublisherPort.publishReportGenerated(request);
            log.info("Report {} completed successfully", reportId);

        } catch (Exception e) {
            log.error("Error processing report {}: {}", reportId, e.getMessage());
            handleFailure(request, e.getMessage());
        }
    }

    private void handleFailure(ReportRequest request, String error) {
        if (request.canRetry()) {
            log.warn("Retrying report {} (Attempt {})", request.getId(), request.getRetryCount() + 1);
            request.markForRetry(error);
            repositoryPort.save(request);
            // Re-publish for internal processing (distributed retry)
            eventPublisherPort.publishInternalProcessing(request);
        } else {
            log.error("Report {} failed after max retries", request.getId());
            request.fail("Max retries exceeded. Last error: " + error);
            repositoryPort.save(request);
        }
    }
}
