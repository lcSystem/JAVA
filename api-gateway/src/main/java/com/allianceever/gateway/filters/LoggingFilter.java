package com.allianceever.gateway.filters;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cloud.gateway.filter.GatewayFilterChain;
import org.springframework.cloud.gateway.filter.GlobalFilter;
import org.springframework.core.Ordered;
import org.springframework.http.server.reactive.ServerHttpRequest;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

/**
 * Structured logging filter that records:
 * - Request path
 * - HTTP method
 * - Response status
 * - Response time (ms)
 * - Correlation ID
 */
@Component
public class LoggingFilter implements GlobalFilter, Ordered {

    private static final Logger log = LoggerFactory.getLogger(LoggingFilter.class);
    private static final String CORRELATION_ID_HEADER = "X-Correlation-Id";

    @Override
    public Mono<Void> filter(ServerWebExchange exchange, GatewayFilterChain chain) {
        ServerHttpRequest request = exchange.getRequest();
        long startTime = System.currentTimeMillis();

        String method = request.getMethod().name();
        String path = request.getURI().getPath();
        String correlationId = request.getHeaders().getFirst(CORRELATION_ID_HEADER);

        log.info("[→] {} {} | correlationId={}", method, path, correlationId);

        return chain.filter(exchange).then(Mono.fromRunnable(() -> {
            ServerHttpResponse response = exchange.getResponse();
            long duration = System.currentTimeMillis() - startTime;
            int status = response.getStatusCode() != null ? response.getStatusCode().value() : 0;

            log.info("[←] {} {} | status={} | time={}ms | correlationId={}",
                    method, path, status, duration, correlationId);
        }));
    }

    @Override
    public int getOrder() {
        return -1; // Run after correlation ID filter
    }
}
