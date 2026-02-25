package com.reportes.domain.model.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportColumn {
    private String id;
    private String title;
    private String dataKey; // The JSON path/key to extract data from
    private int orderIndex;
    private int width; // percentage or fixed px
    private String dataType; // STRING, NUMBER, DATE, BOOLEAN

    @Builder.Default
    private boolean visible = true;

    // Styling
    private String backgroundColor;
    private String textColor;
    private String align; // left, center, right
}
