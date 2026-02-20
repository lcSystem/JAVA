package com.reportes.infrastructure.config;

import org.springframework.amqp.core.*;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMqConfig {

    public static final String EXCHANGE = "reports.exchange";
    public static final String QUEUE = "reports.queue";
    public static final String DLQ = "reports.dlq";
    public static final String INTERNAL_PROCESS_QUEUE = "reports.internal.processing";

    @Bean
    public TopicExchange reportsExchange() {
        return new TopicExchange(EXCHANGE);
    }

    @Bean
    public Queue reportsQueue() {
        return QueueBuilder.durable(QUEUE)
                .withArgument("x-dead-letter-exchange", EXCHANGE)
                .withArgument("x-dead-letter-routing-key", "reports.dlq")
                .build();
    }

    @Bean
    public Queue reportsDlq() {
        return new Queue(DLQ);
    }

    @Bean
    public Queue internalProcessQueue() {
        return new Queue(INTERNAL_PROCESS_QUEUE);
    }

    @Bean
    public Binding reportsBinding(Queue reportsQueue, TopicExchange reportsExchange) {
        return BindingBuilder.bind(reportsQueue).to(reportsExchange).with("reports.requested");
    }

    @Bean
    public Binding dlqBinding(Queue reportsDlq, TopicExchange reportsExchange) {
        return BindingBuilder.bind(reportsDlq).to(reportsExchange).with("reports.dlq");
    }
}
