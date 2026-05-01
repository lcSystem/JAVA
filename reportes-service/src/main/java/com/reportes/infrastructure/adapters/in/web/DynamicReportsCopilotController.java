package com.reportes.infrastructure.adapters.in.web;

import com.reportes.application.ports.in.dynamic.QueryValidationResponse;
import com.reportes.application.services.AiSqlAssistantService;
import com.reportes.application.services.HybridQueryValidatorService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reports/copilot")
@RequiredArgsConstructor
@Slf4j
public class DynamicReportsCopilotController {

    private final HybridQueryValidatorService hybridQueryValidatorService;
    private final AiSqlAssistantService aiSqlAssistantService;

    @PostMapping("/validate")
    public ResponseEntity<QueryValidationResponse> validateAndExplainQuery(@RequestBody Map<String, String> payload) {
        String query = payload.get("query");

        // 1. AST + DryRun Check
        QueryValidationResponse response = hybridQueryValidatorService.validateSintaxAndDryRun(query);

        // 2. Si pasa las comprobaciones básicas o si es necesario, generamos el AI
        // Explanation
        if (response.isAstValid()) {
            String aiResult = aiSqlAssistantService.explainQueryAndSuggestOptimizations(query);
            // Expected format: "Explanation|Optimizations"
            if (aiResult.contains("|")) {
                String[] parts = aiResult.split("\\|");
                response.setAiExplanation(parts[0].trim());
                response.setAiOptimizationSuggestions(List.of(parts[1].trim()));
            } else {
                response.setAiExplanation(aiResult);
                response.setAiOptimizationSuggestions(List.of("Revisa la indexación genérica."));
            }
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/generate")
    public ResponseEntity<Map<String, String>> generateSql(@RequestBody Map<String, String> payload) {
        String nlPrompt = payload.get("prompt");
        String module = payload.getOrDefault("module", "");

        String generatedSql = aiSqlAssistantService.generateQueryFromNaturalLanguage(nlPrompt, module);

        return ResponseEntity.ok(Map.of("generatedSql", generatedSql));
    }
}
