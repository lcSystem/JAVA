package com.creditos.infrastructure.configuration;

import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.config.SimpleRabbitListenerContainerFactory;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQConfig {

    public static final String USER_QUEUE = "creditos.user.queue";
    public static final String USER_DLQ = "creditos.user.dlq";
    public static final String USER_EXCHANGE = "user.exchange";
    public static final String USER_DLX = "user.exchange.dlx";
    public static final String USER_ROUTING_KEY = "user.events.v1";

    @Bean
    public Queue userQueue() {
        return QueueBuilder.durable(USER_QUEUE)
                .withArgument("x-dead-letter-exchange", USER_DLX)
                .withArgument("x-dead-letter-routing-key", USER_ROUTING_KEY)
                .build();
    }

    @Bean
    public Queue userDLQ() {
        return QueueBuilder.durable(USER_DLQ).build();
    }

    @Bean
    public TopicExchange userExchange() {
        return new TopicExchange(USER_EXCHANGE);
    }

    @Bean
    public TopicExchange userDLX() {
        return new TopicExchange(USER_DLX);
    }

    @Bean
    public Binding userBinding(Queue userQueue, TopicExchange userExchange) {
        return BindingBuilder.bind(userQueue).to(userExchange).with(USER_ROUTING_KEY);
    }

    @Bean
    public Binding userDLQBinding(Queue userDLQ, TopicExchange userDLX) {
        return BindingBuilder.bind(userDLQ).to(userDLX).with(USER_ROUTING_KEY);
    }

    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }

    @Bean
    public SimpleRabbitListenerContainerFactory rabbitListenerContainerFactory(ConnectionFactory connectionFactory) {
        SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
        factory.setConnectionFactory(connectionFactory);
        factory.setMessageConverter(jsonMessageConverter());
        factory.setConcurrentConsumers(3);
        factory.setMaxConcurrentConsumers(10);
        return factory;
    }
}
