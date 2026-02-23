package com.allianceever.portfolio.infrastructure.client;

import com.allianceever.portfolio.domain.ports.out.IamClientPort;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.*;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Slf4j
public class IamServiceClient implements IamClientPort {

    private final RestTemplate restTemplate;
    private final String baseUrl;

    public IamServiceClient(RestTemplate restTemplate, String baseUrl) {
        this.restTemplate = restTemplate;
        this.baseUrl = baseUrl;
    }

    @Override
    public boolean validatePassword(String username, String password) {
        try {
            String url = baseUrl + "/api/auth/login";
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> body = Map.of(
                    "userName", username,
                    "password", password);

            HttpEntity<Map<String, String>> request = new HttpEntity<>(body, headers);
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.POST, request, String.class);

            return response.getStatusCode().is2xxSuccessful();
        } catch (Exception e) {
            log.warn("Password validation failed for user {}: {}", username, e.getMessage());
            return false;
        }
    }
}
