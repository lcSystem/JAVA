package com.reportes.application.services;

import com.reportes.application.ports.in.dynamic.QueryValidationResponse;
import net.sf.jsqlparser.JSQLParserException;
import net.sf.jsqlparser.parser.CCJSqlParserUtil;
import net.sf.jsqlparser.statement.Statement;
import net.sf.jsqlparser.statement.select.Select;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class HybridQueryValidatorService {

    @Autowired
    private NamedParameterJdbcTemplate jdbcTemplate;

    /**
     * Executes Layer 2 (Syntax AST Security) and Layer 3 (Transactional Dry Run
     * limit 1)
     */
    @Transactional(readOnly = true)
    public QueryValidationResponse validateSintaxAndDryRun(String rawQuery) {
        QueryValidationResponse response = new QueryValidationResponse();

        if (rawQuery == null || rawQuery.isBlank()) {
            response.setAstValid(false);
            response.setAstErrorDetail("La consulta está vacía.");
            return response;
        }

        // 1. Layer 2: AST Parser Validation
        try {
            // Eliminar punto y coma final si existe para que JSQLParser o JDBC no se
            // asusten
            String cleanQuery = rawQuery.trim();
            if (cleanQuery.endsWith(";")) {
                cleanQuery = cleanQuery.substring(0, cleanQuery.length() - 1);
            }

            Statement statement = CCJSqlParserUtil.parse(cleanQuery);
            if (!(statement instanceof Select)) {
                response.setAstValid(false);
                response.setAstErrorDetail(
                        "Violación de Seguridad: El AST detectó una sentencia que NO es un SELECT válido.");
                return response;
            }
            response.setAstValid(true);
        } catch (JSQLParserException e) {
            response.setAstValid(false);
            response.setAstErrorDetail("Error de sintaxis SQL (AST): " + e.getMessage());
            return response;
        }

        // 2. Layer 3: Smart Dry Run (Transaction ReadOnly with limits to infer
        // Metadata)
        try {
            // Injecting a strict LIMIT 1 locally for performance, while rollback context
            // ensures safety
            String cleanQueryForDb = rawQuery.trim();
            if (cleanQueryForDb.endsWith(";")) {
                cleanQueryForDb = cleanQueryForDb.substring(0, cleanQueryForDb.length() - 1);
            }

            String dryRunQuery = "SELECT * FROM (" + cleanQueryForDb + ") AS dry_run_table LIMIT 1";

            List<QueryValidationResponse.ColumnMetadata> extractedMetadata = new ArrayList<>();

            // Executing the smart dry run wrapper. If SQL is malicious, even in AST
            // bypassed, ReadOnly will block DML,
            // or the nested FROM wrap will throw Syntax Exception.
            jdbcTemplate.query(dryRunQuery, Map.of(), rs -> {
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                for (int i = 1; i <= columnCount; i++) {
                    extractedMetadata.add(QueryValidationResponse.ColumnMetadata.builder()
                            .name(metaData.getColumnLabel(i))
                            .type(metaData.getColumnTypeName(i))
                            .build());
                }
                return null;
            });

            response.setExecutionValid(true);
            response.setExpectedColumns(extractedMetadata);
            response.setExecutionErrorDetail("Validación exitosa");

        } catch (Exception e) {
            response.setExecutionValid(false);
            response.setExecutionErrorDetail("Error en Smart Dry Run BD: " + e.getMessage());
        }

        return response;
    }
}
