package com.reportes.infrastructure.messaging.publisher;

import com.reportes.domain.model.InternalProcessingEvent;
import com.reportes.domain.model.ReportRequest;
import com.reportes.domain.ports.out.EventPublisherPort;
import com.reportes.infrastructure.config.RabbitMqConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class RabbitMqEventPublisher implements EventPublisherPort {

    private final RabbitTemplate rabbitTemplate;

    @Override
    public void publishReportGenerated(ReportRequest reportRequest) {
        log.info("Publishing report generated event for {}", reportRequest.getId());
        rabbitTemplate.convertAndSend(RabbitMqConfig.EXCHANGE, "reports.generated", reportRequest.getId().toString());
    }

    @Override
    public void publishInternalProcessing(ReportRequest reportRequest) {
        log.info("Publishing internal processing request for report {}", reportRequest.getId());
        InternalProcessingEvent event = new InternalProcessingEvent(reportRequest.getId(),
                reportRequest.getRetryCount());
        rabbitTemplate.convertAndSend(RabbitMqConfig.INTERNAL_PROCESS_QUEUE, event);
    }
}
