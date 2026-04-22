-- Flyway migration to safely remove the 4 practice modules and their child options

-- First, delete permissions associated with the submenus of the practice modules
DELETE FROM role_menu_permission
WHERE
    menu_id IN (
        SELECT id
        FROM menu
        WHERE
            code IN (
                'EMPLEADOS',
                'DEPARTAMENTOS',
                'CARGOS',
                'CLIENTES',
                'PROYECTOS',
                'TAREAS',
                'FACTURAS',
                'PRESUPUESTOS',
                'GASTOS',
                'PAGOS',
                'PERMISOS_RRHH'
            )
    );

-- Delete the practice submenus
DELETE FROM menu
WHERE
    code IN (
        'EMPLEADOS',
        'DEPARTAMENTOS',
        'CARGOS',
        'CLIENTES',
        'PROYECTOS',
        'TAREAS',
        'FACTURAS',
        'PRESUPUESTOS',
        'GASTOS',
        'PAGOS',
        'PERMISOS_RRHH'
    );

-- Delete permissions associated with the parent practice modules
DELETE FROM role_menu_permission
WHERE
    menu_id IN (
        SELECT id
        FROM menu
        WHERE
            code IN (
                'GRP_GESTION',
                'GRP_PROYECTOS',
                'GRP_FINANZAS',
                'GRP_RRHH'
            )
    );

-- Delete the parent practice modules
DELETE FROM menu
WHERE
    code IN (
        'GRP_GESTION',
        'GRP_PROYECTOS',
        'GRP_FINANZAS',
        'GRP_RRHH'
    );