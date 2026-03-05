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
public class CreditsApiDataSourceAdapter extends BaseApiDataSourceAdapter {

    public static final String CREDIT_REQUESTS = "CREDIT_REQUESTS";
    public static final String CODEBTOR_PROFILES = "CODEBTOR_PROFILES";

    public CreditsApiDataSourceAdapter(
            WebClient.Builder webClientBuilder,
            ObjectMapper objectMapper,
            @Value("${services.creditos-web.url:http://localhost:8082}") String baseUrl) {
        super(webClientBuilder, objectMapper, baseUrl);
    }

    @Override
    public boolean supports(String dataSourceId) {
        return CREDIT_REQUESTS.equals(dataSourceId) || CODEBTOR_PROFILES.equals(dataSourceId);
    }

    @Override
    @CircuitBreaker(name = "creditsDataSource", fallbackMethod = "fetchDataFallback")
    @Retry(name = "creditsDataSource")
    public List<Map<String, Object>> fetchData(String dataSourceId, Map<String, Object> filters, String authToken) {
        String endpoint = CREDIT_REQUESTS.equals(dataSourceId)
                ? "/api/v1/credit-requests"
                : "/api/v1/codebtor-profiles";

        return fetchPaginatedData(endpoint, filters, authToken);
    }

    public List<Map<String, Object>> fetchDataFallback(String dataSourceId, Map<String, Object> filters,
            String authToken, Throwable t) {
        throw new RuntimeException("Service Credits is unavailable for data extraction: " + t.getMessage(), t);
    }
}
