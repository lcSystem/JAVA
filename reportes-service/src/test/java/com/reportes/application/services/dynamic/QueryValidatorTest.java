package com.reportes.application.services.dynamic;

import com.reportes.domain.exception.IllegalSqlOperationException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

class QueryValidatorTest {

    private QueryValidator queryValidator;

    @BeforeEach
    void setUp() {
        queryValidator = new QueryValidator();
    }

    @Test
    void validate_ValidSelectQuery_ShouldPass() {
        String validQuery = "SELECT id, name, created_at FROM users WHERE active = true";
        assertDoesNotThrow(() -> queryValidator.validate(validQuery));
    }

    @Test
    void validate_ValidWithQuery_ShouldPass() {
        String validQuery = "WITH RECURSIVE t AS (SELECT 1) SELECT * FROM t;";
        assertDoesNotThrow(() -> queryValidator.validate(validQuery));
    }

    @Test
    void validate_QueryWithMultiLineSelect_ShouldPass() {
        String validQuery = " \n  SELECT \n id, name \n FROM users";
        assertDoesNotThrow(() -> queryValidator.validate(validQuery));
    }

    @Test
    void validate_EmptyQuery_ShouldThrowException() {
        String emptyQuery = "   ";
        Exception e = assertThrows(IllegalSqlOperationException.class, () -> queryValidator.validate(emptyQuery));
        assertTrue(e.getMessage().contains("cannot be empty"));
    }

    @Test
    void validate_QueryStartingWithInsert_ShouldThrowException() {
        String insertQuery = "INSERT INTO users(name) VALUES('Test')";
        Exception e = assertThrows(IllegalSqlOperationException.class, () -> queryValidator.validate(insertQuery));
        assertTrue(e.getMessage().contains("must begin with SELECT or WITH"));
    }

    @Test
    void validate_SelectQueryWithDrop_ShouldThrowException() {
        String dangerousQuery = "SELECT * FROM users; DROP TABLE audits;";
        Exception e = assertThrows(IllegalSqlOperationException.class, () -> queryValidator.validate(dangerousQuery));
        assertTrue(e.getMessage().contains("Dangerous SQL operation detected"));
    }

    @Test
    void validate_SelectQueryWithDelete_ShouldThrowException() {
        String dangerousQuery = "SELECT id FROM accounts WHERE active = false; DELETE FROM accounts;";
        Exception e = assertThrows(IllegalSqlOperationException.class, () -> queryValidator.validate(dangerousQuery));
        assertTrue(e.getMessage().contains("Dangerous SQL operation detected"));
    }

    @Test
    void validate_SelectQueryWithUpdate_ShouldThrowException() {
        String dangerousQuery = "select * from records; update records set val=1;";
        Exception e = assertThrows(IllegalSqlOperationException.class, () -> queryValidator.validate(dangerousQuery));
        assertTrue(e.getMessage().contains("Dangerous SQL operation detected"));
    }
}
