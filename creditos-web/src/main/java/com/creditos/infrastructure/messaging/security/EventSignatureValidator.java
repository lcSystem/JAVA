package com.creditos.infrastructure.messaging.security;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

@Slf4j
@Component
public class EventSignatureValidator {

    @Value("${app.messaging.secret:erp-secret-key}")
    private String secretKey;

    public boolean isValid(String eventId, String type, String timestamp, Object payload, String receivedSignature) {
        try {
            String data = eventId + type + timestamp + payload.toString();
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            String calculatedSignature = Base64.getEncoder()
                    .encodeToString(sha256_HMAC.doFinal(data.getBytes(StandardCharsets.UTF_8)));

            return calculatedSignature.equals(receivedSignature);
        } catch (NoSuchAlgorithmException | InvalidKeyException e) {
            log.error("Error validating signature", e);
            return false;
        }
    }
}
