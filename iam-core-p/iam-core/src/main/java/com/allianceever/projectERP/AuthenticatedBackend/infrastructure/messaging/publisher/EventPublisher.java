package com.allianceever.projectERP.AuthenticatedBackend.infrastructure.messaging.publisher;

import com.allianceever.projectERP.AuthenticatedBackend.infrastructure.messaging.dto.EventEnvelope;
import com.allianceever.projectERP.AuthenticatedBackend.infrastructure.configuration.RabbitMQConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.UUID;

@Slf4j
@Component
@RequiredArgsConstructor
public class EventPublisher {

    private final RabbitTemplate rabbitTemplate;

    @Value("${app.messaging.secret:erp-secret-key}")
    private String secretKey;

    public <T> void publish(String eventType, String version, T payload) {
        String eventId = UUID.randomUUID().toString();
        LocalDateTime now = LocalDateTime.now();

        String signature = calculateSignature(eventId, eventType, now.toString(), payload.toString());

        EventEnvelope<T> envelope = EventEnvelope.<T>builder()
                .eventId(eventId)
                .eventType(eventType)
                .version(version)
                .timestamp(now)
                .payload(payload)
                .signature(signature)
                .source("iam-core")
                .build();

        log.info("Publishing event {} of type {}", eventId, eventType);
        rabbitTemplate.convertAndSend(RabbitMQConfig.USER_EXCHANGE, RabbitMQConfig.USER_ROUTING_KEY, envelope);
    }

    private String calculateSignature(String eventId, String type, String timestamp, String payloadStr) {
        try {
            String data = eventId + type + timestamp + payloadStr;
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            return Base64.getEncoder().encodeToString(sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8)));
        } catch (NoSuchAlgorithmException | InvalidKeyException e) {
            log.error("Error calculating signature", e);
            throw new RuntimeException("Error signing event", e);
        }
    }
}
