package com.reportes.application.services;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class DatabaseSchemaService {

    private final JdbcTemplate jdbcTemplate;

    /**
     * Extrae un resumen del esquema de la base de datos actual para un módulo o
     * palabra clave.
     * Esto alimenta a la IA con contexto real.
     */
    public String getCompactSchemaSummary(String contextKeyword) {
        try {
            // Buscamos tablas que hagan match con la palabra clave en la BD actual.
            // Si el contexto es vacío o general, traemos todas las tablas principales.
            String query = "SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE " +
                    "FROM information_schema.columns " +
                    "WHERE table_schema = DATABASE() ";

            if (contextKeyword != null && !contextKeyword.isBlank()) {
                query += " AND TABLE_NAME LIKE ? ";
            }

            query += " ORDER BY TABLE_NAME, ORDINAL_POSITION";

            List<Map<String, Object>> rows;
            if (contextKeyword != null && !contextKeyword.isBlank()) {
                rows = jdbcTemplate.queryForList(query, "%" + contextKeyword + "%");
            } else {
                rows = jdbcTemplate.queryForList(query);
            }

            // Agrupamos por tabla
            Map<String, List<String>> schemaMap = rows.stream().collect(Collectors.groupingBy(
                    r -> (String) r.get("TABLE_NAME"),
                    Collectors.mapping(r -> r.get("COLUMN_NAME") + " " + r.get("DATA_TYPE"), Collectors.toList())));

            StringBuilder sb = new StringBuilder("Current DB Schema:\n");
            schemaMap.forEach((table, columns) -> {
                sb.append("Table '").append(table).append("': ");
                sb.append(String.join(", ", columns)).append("\n");
            });

            return sb.toString();
        } catch (Exception e) {
            log.error("Failed to extract schema metadata", e);
            return "Schema extraction failed";
        }
    }
}
