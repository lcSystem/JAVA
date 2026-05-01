package com.reportes.domain.model.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StoredReportQuery {
    private String id;
    private String name;
    private String description;
    private String sqlQuery;
    private String createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
