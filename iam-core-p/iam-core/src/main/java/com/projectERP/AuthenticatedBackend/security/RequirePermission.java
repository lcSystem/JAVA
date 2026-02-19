package com.allianceever.projectERP.AuthenticatedBackend.security;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Annotation for method-level RBAC authorization.
 * Validates that the authenticated user has the specified CRUD permission
 * on the specified menu resource.
 * 
 * Usage:
 * 
 * @RequirePermission(menu = "EMPLEADOS", action = "CREATE")
 *                         public EmployeeDto create(@RequestBody EmployeeDto
 *                         dto) { ... }
 * 
 *                         ADMIN role always bypasses this check.
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface RequirePermission {

    /**
     * Menu code (must match the 'codigo' column in the menu table).
     * Example: "EMPLEADOS", "FACTURAS", "PROYECTOS"
     */
    String menu();

    /**
     * CRUD action: "READ", "CREATE", "UPDATE", "DELETE"
     */
    String action();
}
