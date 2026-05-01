package com.reportes.infrastructure.adapters.out.datasource;

import com.reportes.application.services.dynamic.QueryValidator;
import com.reportes.domain.exception.DataFetchException;
import com.reportes.domain.ports.out.DataSourcePort;
import io.github.resilience4j.circuitbreaker.annotation.CircuitBreaker;
import io.github.resilience4j.retry.annotation.Retry;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class DirectQueryDataSourceAdapter implements DataSourcePort {

    public static final String DIRECT_SQL = "DIRECT_SQL";
    private static final int DEFAULT_MAX_RECORDS = 5000;

    private final NamedParameterJdbcTemplate jdbcTemplate;
    private final QueryValidator queryValidator;

    @Override
    public boolean supports(String dataSourceId) {
        return DIRECT_SQL.equals(dataSourceId);
    }

    @Override
    @Transactional(readOnly = true)
    @CircuitBreaker(name = "directSqlDataSource", fallbackMethod = "fetchDataFallback")
    @Retry(name = "directSqlDataSource")
    public List<Map<String, Object>> fetchData(String dataSourceId, Map<String, Object> filters, String authToken) {
        if (filters == null || !filters.containsKey("rawQuery")) {
            throw new IllegalArgumentException("Direct SQL mode requires 'rawQuery' parameter in filters");
        }

        String rawQuery = filters.get("rawQuery").toString();
        log.info("Executing Direct SQL query length: {}", rawQuery.length());

        // 1. Mandatory Security Validation
        queryValidator.validate(rawQuery);

        // 2. Resolve Parameters
        int maxRecords = DEFAULT_MAX_RECORDS;
        if (filters.containsKey("maxRecords")) {
            try {
                maxRecords = Integer.parseInt(filters.get("maxRecords").toString());
            } catch (NumberFormatException e) {
                log.warn("Invalid maxRecords provided, using default {}", maxRecords);
            }
        }
        final int limit = maxRecords;

        MapSqlParameterSource paramSource = new MapSqlParameterSource();
        // Bind dynamic filters excluding our internal control keys
        filters.forEach((k, v) -> {
            if (!"rawQuery".equals(k) && !"maxRecords".equals(k)) {
                paramSource.addValue(k, v);
            }
        });

        // 3. Execute using Result Set Extractor / Streaming to prevent memory overload
        try {
            return jdbcTemplate.query(rawQuery, paramSource, rs -> {
                List<Map<String, Object>> results = new ArrayList<>();
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();

                int count = 0;
                while (rs.next() && count < limit) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columnCount; i++) {
                        String colName = metaData.getColumnLabel(i);
                        Object value = rs.getObject(i);
                        row.put(colName, value);
                    }
                    results.add(row);
                    count++;
                }

                if (rs.next()) {
                    log.warn("Result set exceeded max records limit ({}), stopping extraction", limit);
                }

                return results;
            });
        } catch (Exception e) {
            log.error("Failed to execute direct SQL query", e);
            throw new DataFetchException("Direct SQL Execution failed: " + e.getMessage(), e);
        }
    }

    public List<Map<String, Object>> fetchDataFallback(String dataSourceId, Map<String, Object> filters,
            String authToken, Throwable t) {
        log.error("Direct SQL fallback triggered due to: {}", t.getMessage());
        throw new RuntimeException(
                "Direct SQL Database is currently unavailable or query is failing consecutively: " + t.getMessage(), t);
    }
}
