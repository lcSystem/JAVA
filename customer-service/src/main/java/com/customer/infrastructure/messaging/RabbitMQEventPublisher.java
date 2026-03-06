package com.customer.infrastructure.messaging;

import com.customer.domain.ports.out.EventPublisherPort;
import lombok.RequiredArgsConstructor;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@RequiredArgsConstructor
public class RabbitMQEventPublisher implements EventPublisherPort {

    private final RabbitTemplate rabbitTemplate;
    private static final String EXCHANGE = "customer.events";

    @Override
    public void publishCustomerCreated(Long customerId) {
        publish("customer.created", "CUSTOMER_CREATED", customerId);
    }

    @Override
    public void publishCustomerUpdated(Long customerId) {
        publish("customer.updated", "CUSTOMER_UPDATED", customerId);
    }

    @Override
    public void publishCustomerDeleted(Long customerId) {
        publish("customer.deleted", "CUSTOMER_DELETED", customerId);
    }

    private void publish(String routingKey, String eventType, Long customerId) {
        CustomerEvent event = CustomerEvent.builder()
                .eventType(eventType)
                .customerId(customerId)
                .timestamp(LocalDateTime.now())
                .source("customer-service")
                .build();
        rabbitTemplate.convertAndSend(EXCHANGE, routingKey, event);
    }
}
