package com.allianceever.creditos.infrastructure.messaging.consumer;

import com.allianceever.creditos.infrastructure.messaging.dto.EventEnvelope;
import com.allianceever.creditos.infrastructure.messaging.dto.UserEventV1;
import com.allianceever.creditos.infrastructure.messaging.security.EventSignatureValidator;
import com.allianceever.creditos.infrastructure.persistence.entity.ProcessedEvent;
import com.allianceever.creditos.infrastructure.persistence.repository.ProcessedEventRepository;
import com.allianceever.creditos.infrastructure.configuration.RabbitMQConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Slf4j
@Component
@RequiredArgsConstructor
public class UserEventConsumer {

    private final EventSignatureValidator signatureValidator;
    private final ProcessedEventRepository processedEventRepository;

    @RabbitListener(queues = RabbitMQConfig.USER_QUEUE)
    @Transactional
    public void consumeUserEvent(EventEnvelope<UserEventV1> envelope) {
        log.info("Received event {} of type {}", envelope.getEventId(), envelope.getEventType());

        // 1. Signature Validation
        if (!signatureValidator.isValid(envelope.getEventId(), envelope.getEventType(),
                envelope.getTimestamp().toString(), envelope.getPayload(), envelope.getSignature())) {
            log.error("Invalid signature for event {}. Rejecting.", envelope.getEventId());
            return;
        }

        // 2. Idempotency Check (processed_events table acts as a lock)
        if (processedEventRepository.existsById(envelope.getEventId())) {
            log.warn("Event {} already processed. Skipping.", envelope.getEventId());
            return;
        }

        try {
            // Mark as processed early to handle parallel duplicates via DB unique
            // constraint
            processedEventRepository.save(ProcessedEvent.builder()
                    .eventId(envelope.getEventId())
                    .eventType(envelope.getEventType())
                    .processedAt(LocalDateTime.now())
                    .build());

            processEvent(envelope);

        } catch (Exception e) {
            log.error("Error processing event {}", envelope.getEventId(), e);
            throw e; // Trigger DLQ/Retry
        }
    }

    private void processEvent(EventEnvelope<UserEventV1> envelope) {
        UserEventV1 payload = envelope.getPayload();
        log.info("Processing {} for user {}", payload.getAction(), payload.getUsername());

        // TODO: Implement actual business logic to sync ApplicantProfile
        // This will call a UseCase in the application layer.
    }
}
