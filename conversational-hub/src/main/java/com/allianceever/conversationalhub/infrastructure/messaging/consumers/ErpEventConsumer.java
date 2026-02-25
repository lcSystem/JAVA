package com.allianceever.conversationalhub.infrastructure.messaging.consumers;

import com.allianceever.conversationalhub.domain.entities.Channel;
import com.allianceever.conversationalhub.domain.ports.in.ChatUseCase;
import com.allianceever.conversationalhub.domain.ports.out.ChannelRepositoryPort;
import com.allianceever.conversationalhub.infrastructure.messaging.config.RabbitMQConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Optional;

@Component
@RequiredArgsConstructor
@Slf4j
public class ErpEventConsumer {
    private final ChatUseCase chatService;
    private final ChannelRepositoryPort channelRepository;

    @RabbitListener(queues = RabbitMQConfig.CHAT_QUEUE)
    public void handleErpEvent(Map<String, Object> event) {
        String eventType = (String) event.get("type");
        log.info("Received ERP event: {}", eventType);

        if ("order.created".equals(eventType)) {
            String orderId = (String) event.get("id");
            String tenantId = (String) event.get("tenantId");

            // Idempotency check: check if channel already exists for this order
            Optional<Channel> existingChannel = channelRepository.findByErpEntity(orderId, "ORDER");
            if (existingChannel.isPresent()) {
                log.info("Channel already exists for order: {}. Skipping creation.", orderId);
                return;
            }

            Channel automaticChannel = Channel.builder()
                    .name("Order-" + orderId)
                    .description("Automatic channel for order " + orderId)
                    .tenantId(tenantId)
                    .erpEntityId(orderId)
                    .erpEntityType("ORDER")
                    .isAutomatic(true)
                    .build();

            chatService.createChannel(automaticChannel);
            log.info("Automatic channel created for order: {}", orderId);
        }
    }
}
