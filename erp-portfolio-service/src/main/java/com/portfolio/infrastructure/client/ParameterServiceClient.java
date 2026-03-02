package com.portfolio.infrastructure.client;

import com.portfolio.domain.model.PortfolioSettings;
import com.portfolio.domain.ports.out.ParameterClientPort;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Slf4j
public class ParameterServiceClient implements ParameterClientPort {

    private final RestTemplate restTemplate;
    private final String baseUrl;

    public ParameterServiceClient(RestTemplate restTemplate, String baseUrl) {
        this.restTemplate = restTemplate;
        this.baseUrl = baseUrl;
    }

    @Override
    @SuppressWarnings("unchecked")
    public Optional<PortfolioSettings> fetchPortfolioSettings() {
        try {
            String url = baseUrl + "/api/parameters/" + "erp-portfolio-service";
            ResponseEntity<List> response = restTemplate.getForEntity(url, List.class);

            if (response.getBody() == null || response.getBody().isEmpty()) {
                return Optional.empty();
            }

            Map<String, String> params = new HashMap<>();
            for (Object item : response.getBody()) {
                if (item instanceof Map) {
                    Map<String, Object> map = (Map<String, Object>) item;
                    String key = (String) map.get("key");
                    String value = (String) map.get("value");
                    if (key != null && value != null) {
                        params.put(key, value);
                    }
                }
            }

            if (params.isEmpty()) {
                return Optional.empty();
            }

            int maxSize = Integer.parseInt(params.getOrDefault("max_file_size_mb", "10"));
            String extStr = params.getOrDefault("allowed_extensions",
                    "jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,ppt,pptx");
            boolean reAuth = Boolean.parseBoolean(params.getOrDefault("require_reauth", "false"));

            return Optional.of(PortfolioSettings.builder()
                    .maxFileSizeMb(maxSize)
                    .allowedExtensions(Arrays.asList(extStr.split(",")))
                    .requireReAuth(reAuth)
                    .build());

        } catch (Exception e) {
            log.warn("Failed to fetch portfolio settings from Parameter service: {}", e.getMessage());
            return Optional.empty();
        }
    }
}
