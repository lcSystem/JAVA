package com.reportes.application.services.dynamic;

import com.reportes.domain.exception.IllegalSqlOperationException;
import org.springframework.stereotype.Component;
import java.util.regex.Pattern;

@Component
public class QueryValidator {

    // Regex to detect dangerous SQL commands (case insensitive)
    private static final Pattern DANGEROUS_SQL_PATTERN = Pattern.compile(
            "\\b(INSERT|UPDATE|DELETE|DROP|TRUNCATE|ALTER|GRANT|REVOKE)\\b",
            Pattern.CASE_INSENSITIVE);

    // Regex to ensure the query starts with a valid read operation
    private static final Pattern VALID_START_PATTERN = Pattern.compile(
            "^\\s*(SELECT|WITH)\\b.*",
            Pattern.CASE_INSENSITIVE | Pattern.DOTALL);

    /**
     * Validates a given SQL query to prevent DDL/DML operations.
     * 
     * @param sql The raw SQL query string to be validated.
     * @throws IllegalSqlOperationException if the query contains banned keywords or
     *                                      doesn't start with SELECT/WITH.
     */
    public void validate(String sql) {
        if (sql == null || sql.trim().isEmpty()) {
            throw new IllegalSqlOperationException("SQL query cannot be empty");
        }

        if (!VALID_START_PATTERN.matcher(sql).matches()) {
            throw new IllegalSqlOperationException("Query must begin with SELECT or WITH");
        }

        if (DANGEROUS_SQL_PATTERN.matcher(sql).find()) {
            throw new IllegalSqlOperationException("Dangerous SQL operation detected (INSERT, UPDATE, DELETE, etc.)");
        }
    }
}
