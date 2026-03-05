package com.reportes.infrastructure.adapters.out.datasource;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.reportes.domain.exception.DataFetchException;
import com.reportes.domain.ports.out.DataSourcePort;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpHeaders;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
public abstract class BaseApiDataSourceAdapter implements DataSourcePort {

    protected static final int MAX_RECORDS = 10_000;
    protected static final int PAGE_SIZE = 1000;

    protected final WebClient webClient;
    private final ObjectMapper objectMapper;

    protected BaseApiDataSourceAdapter(WebClient.Builder webClientBuilder, ObjectMapper objectMapper, String baseUrl) {
        this.webClient = webClientBuilder.baseUrl(baseUrl).build();
        this.objectMapper = objectMapper;
    }

    protected List<Map<String, Object>> fetchPaginatedData(String endpoint, Map<String, Object> filters,
            String authToken) {
        List<Map<String, Object>> allData = new ArrayList<>();
        int page = 0;
        boolean hasMore = true;

        log.info("Starting paginated data fetch from endpoint: {}", endpoint);

        while (hasMore) {
            String url = endpoint + (endpoint.contains("?") ? "&" : "?") + "page=" + page + "&size=" + PAGE_SIZE;

            // Add custom filters to query params
            if (filters != null && !filters.isEmpty()) {
                StringBuilder filterParams = new StringBuilder();
                filters.forEach((k, v) -> filterParams.append("&").append(k).append("=").append(v));
                url += filterParams.toString();
            }

            log.debug("Fetching page {} from {}", page, url);

            try {
                // Here we expect the downstream microservice to return a Spring Data Page
                // format
                // or a simple list. We will handle both cases.
                Object response = webClient.get()
                        .uri(url)
                        .header(HttpHeaders.AUTHORIZATION, authToken)
                        .retrieve()
                        .bodyToMono(Object.class)
                        .block(); // Blocking because report generation is a synchronous process overall for now

                if (response == null) {
                    break;
                }

                List<Map<String, Object>> elements = extractElements(response);

                if (elements.isEmpty()) {
                    hasMore = false;
                } else {
                    allData.addAll(elements);
                    if (elements.size() < PAGE_SIZE) {
                        hasMore = false; // Last page
                    } else {
                        page++;
                    }
                }

                if (allData.size() >= MAX_RECORDS) {
                    log.warn("Max records limit reached ({}). Stopping pagination.", MAX_RECORDS);
                    // Trim down to MAX_RECORDS exact if it exceeded
                    return allData.subList(0, Math.min(allData.size(), MAX_RECORDS));
                }

            } catch (Exception e) {
                log.error("Failed to fetch data from {}", url, e);
                throw new DataFetchException("Failed to fetch data from downstream service: " + e.getMessage(), e);
            }
        }

        log.info("Finished fetching data. Total records: {}", allData.size());
        return allData;
    }

    @SuppressWarnings("unchecked")
    private List<Map<String, Object>> extractElements(Object response) {
        if (response instanceof List) {
            return (List<Map<String, Object>>) response;
        } else if (response instanceof Map) {
            Map<String, Object> mapResponse = (Map<String, Object>) response;
            // Handle Spring Data Page structure
            if (mapResponse.containsKey("content")) {
                return (List<Map<String, Object>>) mapResponse.get("content");
            } else if (mapResponse.containsKey("data")) {
                return (List<Map<String, Object>>) mapResponse.get("data");
            }
        }

        // Try fallback conversion via objectMapper
        try {
            return objectMapper.convertValue(response, new TypeReference<List<Map<String, Object>>>() {
            });
        } catch (Exception e) {
            log.warn("Could not extract list of elements from response format. Assuming single object or unparseable.");
            return new ArrayList<>();
        }
    }
}
