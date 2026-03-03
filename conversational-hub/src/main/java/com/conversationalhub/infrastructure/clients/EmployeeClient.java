package com.conversationalhub.infrastructure.clients;

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
        System.out.println(
                "[EmployeeClient] Token found: "
                        + (token != null ? "YES (length=" + token.length() : "NULL (proceeding anyway)"));

        HttpHeaders headers = new HttpHeaders();
        if (token != null) {
            headers.setBearerAuth(token);
        }
        HttpEntity<Void> entity = new HttpEntity<>(headers);

        try {
            System.out.println("[EmployeeClient] Calling: " + iamBaseUrl + "/api/security/users");
            ResponseEntity<String> rawResponse = restTemplate.exchange(
                    iamBaseUrl + "/api/security/users",
                    HttpMethod.GET,
                    entity,
                    String.class);
            System.out.println("[EmployeeClient] IAM response status: " + rawResponse.getStatusCode());
            String body = rawResponse.getBody();
            System.out.println("[EmployeeClient] IAM response body length: " + (body != null ? body.length() : "null"));
            if (body != null && body.length() < 500) {
                System.out.println("[EmployeeClient] IAM response body: " + body);
            }

            if (body != null) {
                com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
                mapper.configure(com.fasterxml.jackson.databind.DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES,
                        false);
                EmployeeSummaryDTO[] employees = mapper.readValue(body, EmployeeSummaryDTO[].class);
                System.out.println("[EmployeeClient] Parsed " + employees.length + " employees");
                for (EmployeeSummaryDTO emp : employees) {
                    System.out.println("[EmployeeClient]   -> " + emp.getUsername() + " (" + emp.getFirstName() + " "
                            + emp.getLastName() + ")");
                }
                return Arrays.asList(employees);
            }
        } catch (Exception e) {
            System.err.println("[EmployeeClient] Error fetching employees from IAM: " + e.getMessage());
            e.printStackTrace();
        }

        return Collections.emptyList();
    }

    private String getCurrentToken() {
        try {
            org.springframework.web.context.request.RequestAttributes attributes = org.springframework.web.context.request.RequestContextHolder
                    .getRequestAttributes();
            if (attributes instanceof org.springframework.web.context.request.ServletRequestAttributes) {
                jakarta.servlet.http.HttpServletRequest request = ((org.springframework.web.context.request.ServletRequestAttributes) attributes)
                        .getRequest();
                String authHeader = request.getHeader("Authorization");
                if (authHeader != null && authHeader.startsWith("Bearer ")) {
                    return authHeader.substring(7);
                }
            }
        } catch (Exception e) {
            System.err.println("Error extracting token: " + e.getMessage());
        }

        // Fallback to SecurityContext
        org.springframework.security.core.Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.getPrincipal() instanceof Jwt jwt) {
            return jwt.getTokenValue();
        }
        return null;
    }

    @Data
    @com.fasterxml.jackson.annotation.JsonIgnoreProperties(ignoreUnknown = true)
    public static class EmployeeSummaryDTO {
        private Long userId; // Assuming userId maps back, though Chat uses username as identifier
        private String firstName;
        private String lastName;
        private String username;
        private String email;
        private String profilePicture;
    }
}
