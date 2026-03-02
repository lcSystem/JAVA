package com.parametrizaciones.infrastructure.messaging.adapters;

import com.parametrizaciones.domain.model.events.ParameterUpdatedEvent;
import com.parametrizaciones.domain.ports.out.ParameterEventPublisherPort;
import com.parametrizaciones.infrastructure.messaging.config.RabbitMQConfig;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class RabbitMQEventPublisherAdapter implements ParameterEventPublisherPort {

    private final RabbitTemplate rabbitTemplate;

    @Override
    public void publish(ParameterUpdatedEvent event) {
        String routingKey = "parameter.updated." + event.getServiceName();
        log.info("Publishing parameter updated event for service: {} with key: {}", event.getServiceName(),
                event.getKey());
        rabbitTemplate.convertAndSend(RabbitMQConfig.EXCHANGE_NAME, routingKey, event);
    }
}
