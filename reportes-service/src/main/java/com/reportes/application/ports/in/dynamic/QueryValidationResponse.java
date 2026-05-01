package com.reportes.application.ports.in.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class QueryValidationResponse {

    // Sintagmatic Analysis
    private boolean isAstValid;
    private String astErrorDetail;

    // Execution Simulation Analysis (Dry Run)
    private boolean isExecutionValid;
    private String executionErrorDetail;

    // AI Component Analysis
    private String aiExplanation;
    private List<String> aiOptimizationSuggestions;

    // Extracted Output Metadata
    private List<ColumnMetadata> expectedColumns;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ColumnMetadata {
        private String name;
        private String type;
    }
}
