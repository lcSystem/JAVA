package com.reportes.domain.ports.out;

import java.util.List;
import java.util.Map;

public interface DataSourcePort {
    boolean supports(String dataSourceId);

    List<Map<String, Object>> fetchData(
            String dataSourceId,
            Map<String, Object> filters,
            String authToken);
}
