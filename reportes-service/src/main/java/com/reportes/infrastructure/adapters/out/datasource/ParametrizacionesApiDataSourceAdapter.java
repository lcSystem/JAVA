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
public class ParametrizacionesApiDataSourceAdapter extends BaseApiDataSourceAdapter {

    public static final String SYSTEM_PARAMS = "SYSTEM_PARAMS";

    public ParametrizacionesApiDataSourceAdapter(
            WebClient.Builder webClientBuilder,
            ObjectMapper objectMapper,
            @Value("${services.parametrizaciones.url:http://localhost:8086}") String baseUrl) {
        super(webClientBuilder, objectMapper, baseUrl);
    }

    @Override
    public boolean supports(String dataSourceId) {
        return SYSTEM_PARAMS.equals(dataSourceId);
    }

    @Override
    @CircuitBreaker(name = "parametrizacionesDataSource", fallbackMethod = "fetchDataFallback")
    @Retry(name = "parametrizacionesDataSource")
    public List<Map<String, Object>> fetchData(String dataSourceId, Map<String, Object> filters, String authToken) {
        return fetchPaginatedData("/api/parameters/all", filters, authToken);
    }

    public List<Map<String, Object>> fetchDataFallback(String dataSourceId, Map<String, Object> filters,
            String authToken, Throwable t) {
        throw new RuntimeException("Service Parametrizaciones is unavailable for data extraction: " + t.getMessage(),
                t);
    }
}
