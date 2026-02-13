-- Seed menus matching the frontend sidebar structure
-- These menus map to the routes used in AppSidebar.tsx

-- Root menu groups
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
VALUES (
        'Panel',
        NULL,
        'GridIcon',
        NULL,
        1,
        1
    );

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
VALUES (
        'Gestión',
        NULL,
        'UserCircleIcon',
        NULL,
        2,
        1
    );

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
VALUES (
        'Proyectos',
        NULL,
        'BoxCubeIcon',
        NULL,
        3,
        1
    );

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
VALUES (
        'Finanzas',
        NULL,
        'PieChartIcon',
        NULL,
        4,
        1
    );

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
VALUES (
        'Recursos Humanos',
        NULL,
        'CalenderIcon',
        NULL,
        5,
        1
    );

-- Sub-menus for Panel (parent_id = ID of 'Panel')
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Comercio', '/', NULL, id, 1, 1
FROM menu
WHERE
    nombre = 'Panel'
    AND parent_id IS NULL;

-- Sub-menus for Gestión
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Empleados', '/employees', NULL, id, 1, 1
FROM menu
WHERE
    nombre = 'Gestión'
    AND parent_id IS NULL;

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Clientes', '/clients', NULL, id, 2, 1
FROM menu
WHERE
    nombre = 'Gestión'
    AND parent_id IS NULL;

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Departamentos', '/departments', NULL, id, 3, 1
FROM menu
WHERE
    nombre = 'Gestión'
    AND parent_id IS NULL;

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Cargos', '/designations', NULL, id, 4, 1
FROM menu
WHERE
    nombre = 'Gestión'
    AND parent_id IS NULL;

-- Sub-menus for Proyectos
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Proyectos', '/projects', NULL, id, 1, 1
FROM menu
WHERE
    nombre = 'Proyectos'
    AND parent_id IS NULL;

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Tareas', '/tasks', NULL, id, 2, 1
FROM menu
WHERE
    nombre = 'Proyectos'
    AND parent_id IS NULL;

-- Sub-menus for Finanzas
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Facturas', '/invoices', NULL, id, 1, 1
FROM menu
WHERE
    nombre = 'Finanzas'
    AND parent_id IS NULL;

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Presupuestos', '/estimates', NULL, id, 2, 1
FROM menu
WHERE
    nombre = 'Finanzas'
    AND parent_id IS NULL;

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Pagos', '/payments', NULL, id, 3, 1
FROM menu
WHERE
    nombre = 'Finanzas'
    AND parent_id IS NULL;

-- Sub-menus for Recursos Humanos
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Permisos RRHH', '/leaves', NULL, id, 1, 1
FROM menu
WHERE
    nombre = 'Recursos Humanos'
    AND parent_id IS NULL;

INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Gastos', '/expenses', NULL, id, 2, 1
FROM menu
WHERE
    nombre = 'Recursos Humanos'
    AND parent_id IS NULL;

-- Seed default permissions for each module
INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'PANEL',
        'Ver panel de control'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'EMPLEADOS',
        'Ver empleados'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'EMPLEADOS',
        'Crear/editar empleados'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'CLIENTES',
        'Ver clientes'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'CLIENTES',
        'Crear/editar clientes'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'DEPARTAMENTOS',
        'Ver departamentos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'DEPARTAMENTOS',
        'Crear/editar departamentos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'CARGOS',
        'Ver cargos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'CARGOS',
        'Crear/editar cargos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'PROYECTOS',
        'Ver proyectos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'PROYECTOS',
        'Crear/editar proyectos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'TAREAS',
        'Ver tareas'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'TAREAS',
        'Crear/editar tareas'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'FACTURAS',
        'Ver facturas'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'FACTURAS',
        'Crear/editar facturas'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'PRESUPUESTOS',
        'Ver presupuestos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'PRESUPUESTOS',
        'Crear/editar presupuestos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES ('LEER', 'PAGOS', 'Ver pagos');

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'PAGOS',
        'Crear/editar pagos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'PERMISOS_RRHH',
        'Ver permisos RRHH'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'PERMISOS_RRHH',
        'Crear/editar permisos RRHH'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'GASTOS',
        'Ver gastos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'GASTOS',
        'Crear/editar gastos'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'LEER',
        'CONFIGURACION',
        'Ver configuración'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
VALUES (
        'ESCRIBIR',
        'CONFIGURACION',
        'Gestionar configuración'
    );

-- Link menus to their LEER permissions via asignacion_menu_permiso
-- Panel -> PANEL:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/'
    AND p.recurso = 'PANEL'
    AND p.accion = 'LEER';

-- Empleados -> EMPLEADOS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/employees'
    AND p.recurso = 'EMPLEADOS'
    AND p.accion = 'LEER';

-- Clientes -> CLIENTES:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/clients'
    AND p.recurso = 'CLIENTES'
    AND p.accion = 'LEER';

-- Departamentos -> DEPARTAMENTOS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/departments'
    AND p.recurso = 'DEPARTAMENTOS'
    AND p.accion = 'LEER';

-- Cargos -> CARGOS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/designations'
    AND p.recurso = 'CARGOS'
    AND p.accion = 'LEER';

-- Proyectos -> PROYECTOS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/projects'
    AND p.recurso = 'PROYECTOS'
    AND p.accion = 'LEER';

-- Tareas -> TAREAS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/tasks'
    AND p.recurso = 'TAREAS'
    AND p.accion = 'LEER';

-- Facturas -> FACTURAS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/invoices'
    AND p.recurso = 'FACTURAS'
    AND p.accion = 'LEER';

-- Presupuestos -> PRESUPUESTOS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/estimates'
    AND p.recurso = 'PRESUPUESTOS'
    AND p.accion = 'LEER';

-- Pagos -> PAGOS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/payments'
    AND p.recurso = 'PAGOS'
    AND p.accion = 'LEER';

-- Permisos RRHH -> PERMISOS_RRHH:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/leaves'
    AND p.recurso = 'PERMISOS_RRHH'
    AND p.accion = 'LEER';

-- Gastos -> GASTOS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/expenses'
    AND p.recurso = 'GASTOS'
    AND p.accion = 'LEER';

-- Assign ALL permissions to ADMIN role
INSERT INTO
    asignacion_rol_permiso (rol_id, permiso_id)
SELECT r.role_id, p.id
FROM roles r, permiso p
WHERE
    r.authority = 'ADMIN';