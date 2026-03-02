package com.parametrizaciones.infrastructure.messaging.config;

import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQConfig {

    public static final String EXCHANGE_NAME = "parametrizaciones.exchange";
    public static final String UPDATED_QUEUE = "parametrizaciones.updated.queue";
    public static final String ERROR_QUEUE = "parametrizaciones.error.queue";
    public static final String ROUTING_KEY = "parameter.updated.#";

    @Bean
    public TopicExchange exchange() {
        return new TopicExchange(EXCHANGE_NAME);
    }

    @Bean
    public Queue updatedQueue() {
        return QueueBuilder.durable(UPDATED_QUEUE)
                .withArgument("x-dead-letter-exchange", "")
                .withArgument("x-dead-letter-routing-key", ERROR_QUEUE)
                .build();
    }

    @Bean
    public Queue errorQueue() {
        return QueueBuilder.durable(ERROR_QUEUE).build();
    }

    @Bean
    public Binding binding(Queue updatedQueue, TopicExchange exchange) {
        return BindingBuilder.bind(updatedQueue).to(exchange).with(ROUTING_KEY);
    }

    @Bean
    public Jackson2JsonMessageConverter messageConverter() {
        return new Jackson2JsonMessageConverter();
    }

    @Bean
    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
        RabbitTemplate rabbitTemplate = new RabbitTemplate(connectionFactory);
        rabbitTemplate.setMessageConverter(messageConverter());
        return rabbitTemplate;
    }
}
