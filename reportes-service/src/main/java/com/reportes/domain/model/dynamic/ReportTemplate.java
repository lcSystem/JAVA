package com.reportes.domain.model.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReportTemplate {
    private UUID id;
    private String name;
    private String description;

    @Builder.Default
    private ReportConfig config = new ReportConfig();

    @Builder.Default
    private List<ReportColumn> columns = new ArrayList<>();

    @Builder.Default
    private List<ReportChart> charts = new ArrayList<>();

    private String createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
