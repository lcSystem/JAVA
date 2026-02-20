package com.reportes.infrastructure.messaging.consumer;

import com.reportes.domain.ports.in.RequestReportUseCase;
import com.reportes.domain.ports.out.ReportRepositoryPort;
import com.reportes.infrastructure.config.RabbitMqConfig;
import com.reportes.infrastructure.messaging.ReportRequestedEvent;
import com.reportes.domain.model.InternalProcessingEvent;
import com.reportes.application.services.AsyncReportProcessor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Slf4j
public class RabbitMqReportConsumer {

    private final RequestReportUseCase requestReportUseCase;
    private final ReportRepositoryPort repositoryPort;
    private final AsyncReportProcessor asyncReportProcessor;

    @Value("${report.security.hmac-secret:change-me-secret}")
    private String hmacSecret;

    @RabbitListener(queues = RabbitMqConfig.QUEUE)
    public void consumeReportRequest(ReportRequestedEvent event) {
        log.info("Received event {} for report type {}", event.getEventId(), event.getPayload().getReportType());

        // 1. Idempotency Check
        if (repositoryPort.isEventProcessed(event.getEventId())) {
            log.warn("Event {} already processed. Skipping.", event.getEventId());
            return;
        }

        // 2. HMAC Validation
        if (!validateSignature(event)) {
            log.error("Invalid HMAC signature for event {}. Rejecting.", event.getEventId());
            // Should probably send to DLQ or discard
            return;
        }

        // 3. Initiate Report
        UUID reportId = requestReportUseCase.initiateReport(
                event.getPayload().getReportType(),
                event.getPayload().getData(),
                event.getPayload().getRequestedBy());

        // 4. Mark Event as Processed
        repositoryPort.saveProcessedEvent(event.getEventId());

        log.info("Report {} initiated from event {}", reportId, event.getEventId());
    }

    @RabbitListener(queues = RabbitMqConfig.INTERNAL_PROCESS_QUEUE)
    public void consumeInternalProcess(InternalProcessingEvent event) {
        log.info("Internal processing request for report {}", event.getReportId());
        asyncReportProcessor.processAsync(event.getReportId());
    }

    private boolean validateSignature(ReportRequestedEvent event) {
        try {
            String dataToSign = event.getEventId() + event.getTimestamp() + event.getPayload().getData();
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(hmacSecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            byte[] hash = sha256_HMAC.doFinal(dataToSign.getBytes(StandardCharsets.UTF_8));
            String calculatedSignature = Base64.getEncoder().encodeToString(hash);
            return calculatedSignature.equals(event.getSignature());
        } catch (Exception e) {
            log.error("Error validating HMAC: {}", e.getMessage());
            return false;
        }
    }
}
