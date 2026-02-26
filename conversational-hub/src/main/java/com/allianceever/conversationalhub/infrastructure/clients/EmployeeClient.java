package com.allianceever.conversationalhub.infrastructure.clients;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@Component
public class EmployeeClient {

    private final RestTemplate restTemplate;
    private final String iamBaseUrl;

    public EmployeeClient(@Value("${app.iam.base-url:http://localhost:8081}") String iamBaseUrl) {
        this.restTemplate = new RestTemplate();
        this.iamBaseUrl = iamBaseUrl;
    }

    public List<EmployeeSummaryDTO> getAllEmployees() {
        String token = getCurrentToken();
        if (token == null)
            return Collections.emptyList();

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);
        HttpEntity<Void> entity = new HttpEntity<>(headers);

        try {
            ResponseEntity<EmployeeSummaryDTO[]> response = restTemplate.exchange(
                    iamBaseUrl + "/api/employee/all",
                    HttpMethod.GET,
                    entity,
                    EmployeeSummaryDTO[].class);

            if (response.getBody() != null) {
                return Arrays.asList(response.getBody());
            }
        } catch (Exception e) {
            // Log error
            System.err.println("Error fetching employees from IAM: " + e.getMessage());
        }

        return Collections.emptyList();
    }

    private String getCurrentToken() {
        Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (principal instanceof Jwt jwt) {
            return jwt.getTokenValue();
        }
        return null;
    }

    @Data
    public static class EmployeeSummaryDTO {
        private String userName;
        private String first_Name;
        private String last_Name;
        private String email;
    }
}
