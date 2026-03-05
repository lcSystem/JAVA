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
public class PortfolioApiDataSourceAdapter extends BaseApiDataSourceAdapter {

    public static final String PORTFOLIO_FOLDERS = "PORTFOLIO_FOLDERS";

    public PortfolioApiDataSourceAdapter(
            WebClient.Builder webClientBuilder,
            ObjectMapper objectMapper,
            @Value("${services.erp-portfolio.url:http://localhost:8084}") String baseUrl) {
        super(webClientBuilder, objectMapper, baseUrl);
    }

    @Override
    public boolean supports(String dataSourceId) {
        return PORTFOLIO_FOLDERS.equals(dataSourceId);
    }

    @Override
    @CircuitBreaker(name = "portfolioDataSource", fallbackMethod = "fetchDataFallback")
    @Retry(name = "portfolioDataSource")
    public List<Map<String, Object>> fetchData(String dataSourceId, Map<String, Object> filters, String authToken) {
        return fetchPaginatedData("/api/v1/folders", filters, authToken);
    }

    public List<Map<String, Object>> fetchDataFallback(String dataSourceId, Map<String, Object> filters,
            String authToken, Throwable t) {
        throw new RuntimeException("Service Portfolio is unavailable for data extraction: " + t.getMessage(), t);
    }
}
