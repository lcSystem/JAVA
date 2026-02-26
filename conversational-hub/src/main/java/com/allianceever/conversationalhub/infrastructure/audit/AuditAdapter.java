package com.allianceever.conversationalhub.infrastructure.audit;

import com.allianceever.conversationalhub.domain.ports.out.EventPublisherPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class AuditAdapter {
    private final EventPublisherPort eventPublisher;

    public void logAction(String userId, String action, String entityId, String tenantId) {
        Map<String, Object> auditLog = new HashMap<>();
        auditLog.put("userId", userId);
        auditLog.put("action", action);
        auditLog.put("entityId", entityId);
        auditLog.put("tenantId", tenantId);
        auditLog.put("timestamp", LocalDateTime.now());

        eventPublisher.publishEvent("audit.log", auditLog);
    }
}
