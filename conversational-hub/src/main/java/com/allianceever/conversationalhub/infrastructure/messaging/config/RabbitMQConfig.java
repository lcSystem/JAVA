package com.allianceever.conversationalhub.infrastructure.messaging.config;

import org.springframework.amqp.core.*;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.amqp.support.converter.MessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQConfig {

    public static final String ERP_EVENTS_EXCHANGE = "erp.events";
    public static final String CHAT_EVENTS_EXCHANGE = "chat.events";
    public static final String CHAT_QUEUE = "ech.chat.queue";

    @Bean
    public TopicExchange erpEventsExchange() {
        return new TopicExchange(ERP_EVENTS_EXCHANGE);
    }

    @Bean
    public TopicExchange chatEventsExchange() {
        return new TopicExchange(CHAT_EVENTS_EXCHANGE);
    }

    @Bean
    public Queue chatQueue() {
        return QueueBuilder.durable(CHAT_QUEUE)
                .withArgument("x-dead-letter-exchange", "erp.events.dlx")
                .build();
    }

    @Bean
    public Binding chatBinding(Queue chatQueue, TopicExchange erpEventsExchange) {
        return BindingBuilder.bind(chatQueue).to(erpEventsExchange).with("order.*");
    }

    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
