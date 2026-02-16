-- ============================================================
-- V14: IAM RBAC Redesign — Granular CRUD Permissions per Menu
-- ============================================================

-- 1. Add 'codigo' column to menu for backend-level identification
ALTER TABLE menu ADD COLUMN codigo VARCHAR(50) UNIQUE AFTER icono;

-- 2. Populate codigo for existing leaf menus (the actionable ones)
UPDATE menu SET codigo = 'COMERCIO' WHERE ruta = '/';

UPDATE menu SET codigo = 'EMPLEADOS' WHERE ruta = '/employees';

UPDATE menu SET codigo = 'CLIENTES' WHERE ruta = '/clients';

UPDATE menu SET codigo = 'DEPARTAMENTOS' WHERE ruta = '/departments';

UPDATE menu SET codigo = 'CARGOS' WHERE ruta = '/designations';

UPDATE menu SET codigo = 'PROYECTOS' WHERE ruta = '/projects';

UPDATE menu SET codigo = 'TAREAS' WHERE ruta = '/tasks';

UPDATE menu SET codigo = 'FACTURAS' WHERE ruta = '/invoices';

UPDATE menu SET codigo = 'PRESUPUESTOS' WHERE ruta = '/estimates';

UPDATE menu SET codigo = 'PAGOS' WHERE ruta = '/payments';

UPDATE menu SET codigo = 'PERMISOS_RRHH' WHERE ruta = '/leaves';

UPDATE menu SET codigo = 'GASTOS' WHERE ruta = '/expenses';

UPDATE menu SET codigo = 'USUARIOS' WHERE ruta = '/settings/users';

UPDATE menu SET codigo = 'ROLES' WHERE ruta = '/settings/roles';

UPDATE menu
SET
    codigo = 'PERMISOS_CONFIG'
WHERE
    ruta = '/settings/permissions';

UPDATE menu SET codigo = 'AJUSTES' WHERE ruta = '/settings';

-- Parent groups (no ruta, just structural)
UPDATE menu
SET
    codigo = 'GRP_PANEL'
WHERE
    nombre = 'Panel'
    AND parent_id IS NULL
    AND ruta IS NULL;

UPDATE menu
SET
    codigo = 'GRP_GESTION'
WHERE
    nombre = 'Gestión'
    AND parent_id IS NULL
    AND ruta IS NULL;

UPDATE menu
SET
    codigo = 'GRP_PROYECTOS'
WHERE
    nombre = 'Proyectos'
    AND parent_id IS NULL
    AND ruta IS NULL;

UPDATE menu
SET
    codigo = 'GRP_FINANZAS'
WHERE
    nombre = 'Finanzas'
    AND parent_id IS NULL
    AND ruta IS NULL;

UPDATE menu
SET
    codigo = 'GRP_RRHH'
WHERE
    nombre = 'Recursos Humanos'
    AND parent_id IS NULL
    AND ruta IS NULL;

UPDATE menu
SET
    codigo = 'GRP_CONFIG'
WHERE
    nombre = 'Configuración'
    AND parent_id IS NULL
    AND ruta IS NULL;

-- 3. Create the new role_menu_permission table
CREATE TABLE role_menu_permission (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    menu_id BIGINT NOT NULL,
    can_read TINYINT(1) NOT NULL DEFAULT 0,
    can_create TINYINT(1) NOT NULL DEFAULT 0,
    can_update TINYINT(1) NOT NULL DEFAULT 0,
    can_delete TINYINT(1) NOT NULL DEFAULT 0,
    CONSTRAINT fk_rmp_role FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE,
    CONSTRAINT fk_rmp_menu FOREIGN KEY (menu_id) REFERENCES menu (id) ON DELETE CASCADE,
    CONSTRAINT uk_role_menu UNIQUE (role_id, menu_id)
);

CREATE INDEX idx_rmp_role ON role_menu_permission (role_id);

CREATE INDEX idx_rmp_menu ON role_menu_permission (menu_id);

-- 4. Grant ADMIN full access to ALL menus with codigo
INSERT INTO
    role_menu_permission (
        role_id,
        menu_id,
        can_read,
        can_create,
        can_update,
        can_delete
    )
SELECT r.role_id, m.id, 1, 1, 1, 1
FROM roles r, menu m
WHERE
    r.authority = 'ADMIN'
    AND m.codigo IS NOT NULL;

-- 5. Drop old permission tables (order matters for FK constraints)
DROP TABLE IF EXISTS asignacion_menu_permiso;

DROP TABLE IF EXISTS asignacion_rol_permiso;

DROP TABLE IF EXISTS permiso;