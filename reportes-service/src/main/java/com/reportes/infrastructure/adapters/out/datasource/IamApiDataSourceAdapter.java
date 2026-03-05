package com.reportes.infrastructure.adapters.out.datasource;

import com.fasterxml.jackson.databind.ObjectMapper;
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.retry.annotation.Retry;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.List;
import java.util.Map;

@Component
public class IamApiDataSourceAdapter extends BaseApiDataSourceAdapter {

    public static final String USERS_SYSTEM = "USERS_SYSTEM";

    public IamApiDataSourceAdapter(
            WebClient.Builder webClientBuilder,
            ObjectMapper objectMapper,
            @Value("${services.iam-core.url:http://localhost:8081}") String baseUrl) {
        super(webClientBuilder, objectMapper, baseUrl);
    }

    @Override
    public boolean supports(String dataSourceId) {
        return USERS_SYSTEM.equals(dataSourceId);
    }

    @Override
    @CircuitBreaker(name = "iamCoreDataSource", fallbackMethod = "fetchDataFallback")
    @Retry(name = "iamCoreDataSource")
    public List<Map<String, Object>> fetchData(String dataSourceId, Map<String, Object> filters, String authToken) {
        // Here we could use the dataSourceId if this adapter supported multiple ones
        // In this case there's only USERS_SYSTEM, so we fetch from /api/v1/users
        return fetchPaginatedData("/api/v1/users", filters, authToken);
    }

    public List<Map<String, Object>> fetchDataFallback(String dataSourceId, Map<String, Object> filters,
            String authToken, Throwable t) {
        throw new RuntimeException("Service IAM Core is unavailable for data extraction: " + t.getMessage(), t);
    }
}
