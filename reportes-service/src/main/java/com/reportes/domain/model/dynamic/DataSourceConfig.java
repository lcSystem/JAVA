package com.reportes.domain.model.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DataSourceConfig {
    private String dataSourceId;
    private String displayName;
    private Set<String> allowedRoles;
    private List<FieldConfig> fields;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class FieldConfig {
        private String id;
        private String title;
        private String dataKey;
        private String type; // string, number, date, etc.
    }
}
