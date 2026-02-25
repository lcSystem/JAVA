package com.allianceever.conversationalhub.infrastructure.messaging.adapters;

import com.allianceever.conversationalhub.domain.ports.out.EventPublisherPort;
import com.allianceever.conversationalhub.infrastructure.messaging.config.RabbitMQConfig;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class RabbitMQPublisherAdapter implements EventPublisherPort {
    private final RabbitTemplate rabbitTemplate;

    @Override
    public void publishEvent(String routingKey, Object event) {
        rabbitTemplate.convertAndSend(RabbitMQConfig.CHAT_EVENTS_EXCHANGE, routingKey, event);
    }
}
