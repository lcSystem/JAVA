package com.reportes.infrastructure.adapters.out.llm;

import com.reportes.domain.model.ReportType;
import com.reportes.domain.ports.out.LlmGenerationPort;
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.timelimiter.annotation.TimeLimiter;
import io.github.resilience4j.bulkhead.annotation.Bulkhead;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.jsoup.Jsoup;
import org.jsoup.safety.Safelist;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;

import java.util.List;
import java.util.Map;

@Component
@RequiredArgsConstructor
@Slf4j
public class OpenAiLlmAdapter implements LlmGenerationPort {

    private final RestClient restClient;

    @Value("${report.llm.api-url}")
    private String apiUrl;

    @Value("${report.llm.api-key}")
    private String apiKey;

    @Value("${report.llm.model:gpt-3.5-turbo}")
    private String model;

    @Override
    @CircuitBreaker(name = "llmCircuitBreaker")
    @TimeLimiter(name = "llmTimeLimiter")
    @Bulkhead(name = "llmBulkhead")
    public String generateHtml(ReportType type, String prompt) {
        log.info("Requesting LLM for report type {}", type);

        Map<String, Object> requestBody = Map.of(
                "model", model,
                "messages", List.of(
                        Map.of("role", "system", "content",
                                "You are a report generator. Return ONLY clean HTML. No markdown blocks."),
                        Map.of("role", "user", "content", prompt)),
                "max_tokens", 2000);

        ResponseEntity<Map> response = restClient.post()
                .uri(apiUrl)
                .header("Authorization", "Bearer " + apiKey)
                .body(requestBody)
                .retrieve()
                .toEntity(Map.class);

        if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
            List<Map<String, Object>> choices = (List<Map<String, Object>>) response.getBody().get("choices");
            if (choices != null && !choices.isEmpty()) {
                String html = (String) ((Map<String, Object>) choices.get(0).get("message")).get("content");
                return sanitizeHtml(html);
            }
        }

        throw new RuntimeException("LLM generation failed with status: " + response.getStatusCode());
    }

    private String sanitizeHtml(String html) {
        log.debug("Sanitizing LLM output");
        // Using relaxed safelist to allow tables, styles, etc., but stripping scripts.
        return Jsoup.clean(html, Safelist.relaxed().addTags("style"));
    }
}
