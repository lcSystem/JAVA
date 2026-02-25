package com.reportes.domain.model.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportChart {
    private String id;
    private ChartType type; // LINIAR, BAR, PIE
    private String title;

    // Data mapping
    private String xAxisKey;
    private String yAxisKey;

    // Positioning and sizing
    private int width;
    private int height;
    private int orderIndex;

    public enum ChartType {
        LINE, BAR, PIE, DOUGHNUT
    }
}
