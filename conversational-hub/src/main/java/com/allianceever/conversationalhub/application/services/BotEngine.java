package com.allianceever.conversationalhub.application.services;

import com.allianceever.conversationalhub.domain.entities.Message;
import com.allianceever.conversationalhub.domain.ports.out.EventPublisherPort;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
public class BotEngine {
    private final EventPublisherPort eventPublisher;

    public void processMessage(Message message) {
        String content = message.getContent();
        if (content.startsWith("/")) {
            handleCommand(content, message);
        }
    }

    private void handleCommand(String command, Message message) {
        log.info("Processing command: {}", command);
        if (command.startsWith("/aprobar-orden")) {
            String orderId = extractId(command);
            publishCommandEvent("order.approve", orderId, message);
        } else if (command.startsWith("/rechazar-factura")) {
            String invoiceId = extractId(command);
            publishCommandEvent("invoice.reject", invoiceId, message);
        }
    }

    private void publishCommandEvent(String type, String entityId, Message originalMessage) {
        Map<String, Object> commandEvent = new HashMap<>();
        commandEvent.put("type", type);
        commandEvent.put("entityId", entityId);
        commandEvent.put("userId", originalMessage.getSenderId());
        commandEvent.put("channelId", originalMessage.getChannelId());

        eventPublisher.publishEvent("erp.commands", commandEvent);
    }

    private String extractId(String command) {
        String[] parts = command.split(" ");
        return parts.length > 1 ? parts[1] : "";
    }
}
