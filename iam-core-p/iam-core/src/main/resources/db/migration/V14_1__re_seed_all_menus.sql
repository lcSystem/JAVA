-- ============================================================
-- V14.1: Re-seed all Menus and ensure ADMIN has full access
-- ============================================================

-- 1. Seed ROOT groups if they don't exist
INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        orden,
        estado
    )
VALUES (
        'Panel',
        NULL,
        'GridIcon',
        'GRP_PANEL',
        1,
        1
    ),
    (
        'Gestión',
        NULL,
        'UserCircleIcon',
        'GRP_GESTION',
        2,
        1
    ),
    (
        'Proyectos',
        NULL,
        'BoxCubeIcon',
        'GRP_PROYECTOS',
        3,
        1
    ),
    (
        'Finanzas',
        NULL,
        'PieChartIcon',
        'GRP_FINANZAS',
        4,
        1
    ),
    (
        'Recursos Humanos',
        NULL,
        'CalenderIcon',
        'GRP_RRHH',
        5,
        1
    ),
    (
        'Configuración',
        NULL,
        'PlugInIcon',
        'GRP_CONFIG',
        6,
        1
    );

-- 2. Seed Child Menus (using subqueries to find parent IDs by codigo)
-- Panel -> Comercio
INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Comercio', '/', NULL, 'COMERCIO', id, 1, 1
FROM menu
WHERE
    codigo = 'GRP_PANEL'
LIMIT 1;

-- Gestión -> Empleados, Clientes, Departamentos, Cargos
INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Empleados', '/employees', NULL, 'EMPLEADOS', id, 1, 1
FROM menu
WHERE
    codigo = 'GRP_GESTION'
LIMIT 1;

INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Clientes', '/clients', NULL, 'CLIENTES', id, 2, 1
FROM menu
WHERE
    codigo = 'GRP_GESTION'
LIMIT 1;

INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Departamentos', '/departments', NULL, 'DEPARTAMENTOS', id, 3, 1
FROM menu
WHERE
    codigo = 'GRP_GESTION'
LIMIT 1;

INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Cargos', '/designations', NULL, 'CARGOS', id, 4, 1
FROM menu
WHERE
    codigo = 'GRP_GESTION'
LIMIT 1;

-- Proyectos -> Proyectos, Tareas
INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Proyectos', '/projects', NULL, 'PROYECTOS', id, 1, 1
FROM menu
WHERE
    codigo = 'GRP_PROYECTOS'
LIMIT 1;

INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Tareas', '/tasks', NULL, 'TAREAS', id, 2, 1
FROM menu
WHERE
    codigo = 'GRP_PROYECTOS'
LIMIT 1;

-- Finanzas -> Facturas, Presupuestos, Pagos
INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Facturas', '/invoices', NULL, 'FACTURAS', id, 1, 1
FROM menu
WHERE
    codigo = 'GRP_FINANZAS'
LIMIT 1;

INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Presupuestos', '/estimates', NULL, 'PRESUPUESTOS', id, 2, 1
FROM menu
WHERE
    codigo = 'GRP_FINANZAS'
LIMIT 1;

INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Pagos', '/payments', NULL, 'PAGOS', id, 3, 1
FROM menu
WHERE
    codigo = 'GRP_FINANZAS'
LIMIT 1;

-- Recursos Humanos -> Permisos, Gastos
INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Permisos', '/leaves', NULL, 'PERMISOS_RRHH', id, 1, 1
FROM menu
WHERE
    codigo = 'GRP_RRHH'
LIMIT 1;

INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Gastos', '/expenses', NULL, 'GASTOS', id, 2, 1
FROM menu
WHERE
    codigo = 'GRP_RRHH'
LIMIT 1;

-- Ajustes (Standalone or under config)
INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        orden,
        estado
    )
VALUES (
        'Ajustes',
        '/settings',
        'PlugInIcon',
        'AJUSTES',
        7,
        1
    );

-- Configuración -> Usuarios, Roles, Permisos
INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Usuarios', '/settings/users', NULL, 'USUARIOS', id, 1, 1
FROM menu
WHERE
    codigo = 'GRP_CONFIG'
LIMIT 1;

INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Roles', '/settings/roles', NULL, 'ROLES', id, 2, 1
FROM menu
WHERE
    codigo = 'GRP_CONFIG'
LIMIT 1;

INSERT IGNORE INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
SELECT 'Permisos', '/settings/permissions', NULL, 'PERMISOS_CONFIG', id, 3, 1
FROM menu
WHERE
    codigo = 'GRP_CONFIG'
LIMIT 1;

-- 3. Ensure ALL ADMINs have entries in role_menu_permission for ALL menus with codes
-- First, delete existing ADMIN permissions to avoid duplicates and ensure freshness
DELETE FROM role_menu_permission
WHERE
    role_id IN (
        SELECT role_id
        FROM roles
        WHERE
            authority = 'ADMIN'
    );

-- Insert full permissions for ADMIN for every menu that has a code
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