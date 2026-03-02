package com.conversationalhub.domain.ports.out;

public interface EventPublisherPort {
    void publishEvent(String routingKey, Object event);
}
