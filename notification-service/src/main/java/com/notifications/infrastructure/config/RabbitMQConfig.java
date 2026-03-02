package com.notifications.infrastructure.config;

import org.springframework.amqp.core.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQConfig {

    public static final String NOTIFICATION_QUEUE = "chat.notifications.queue";
    public static final String NOTIFICATION_EXCHANGE = "chat.notifications.exchange";

    @Bean
    public Queue notificationQueue() {
        return new Queue(NOTIFICATION_QUEUE, true);
    }

    @Bean
    public FanoutExchange notificationExchange() {
        return new FanoutExchange(NOTIFICATION_EXCHANGE);
    }

    @Bean
    public Binding notificationBinding(Queue notificationQueue, FanoutExchange notificationExchange) {
        return BindingBuilder.bind(notificationQueue).to(notificationExchange);
    }
}
