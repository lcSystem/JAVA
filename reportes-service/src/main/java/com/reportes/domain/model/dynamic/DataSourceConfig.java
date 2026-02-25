package com.reportes.domain.model.dynamic;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DataSourceConfig {
    private String microserviceId;
    private String microserviceName;
    private List<EntityConfig> entities;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EntityConfig {
        private String entityId;
        private String entityName;
        private String endpointUrl;
        private List<FieldConfig> fields;
    }

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
