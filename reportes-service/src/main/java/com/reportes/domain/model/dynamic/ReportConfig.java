package com.reportes.domain.model.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportConfig {
    @Builder.Default
    private String headerColor = "#FFFFFF"; // e.g. white default

    @Builder.Default
    private String headerTextColor = "#000000";

    @Builder.Default
    private String primaryColor = "#3B82F6"; // a default blue for charts or highlights

    @Builder.Default
    private boolean showPageNumbers = true;

    @Builder.Default
    private boolean landscape = false; // vertical by default

    private String logoUrl; // optional company logo
}
