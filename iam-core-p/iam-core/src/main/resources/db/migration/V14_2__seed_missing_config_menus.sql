-- Ensure 'Configuración' parent menu exists
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        orden,
        estado,
        parent_id
    )
SELECT 'Configuración', NULL, 'PlugInIcon', 'CONFIG', 10, 1, NULL
WHERE
    NOT EXISTS (
        SELECT 1
        FROM menu
        WHERE
            codigo = 'CONFIG'
    );

-- Get the ID of the 'Configuración' menu
SET @parent_id = ( SELECT id FROM menu WHERE codigo = 'CONFIG' );

-- Insert 'Usuarios' menu
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        orden,
        estado,
        parent_id
    )
SELECT 'Usuarios', '/settings/users', 'UserCircleIcon', 'CONFIG_USERS', 1, 1, @parent_id
WHERE
    NOT EXISTS (
        SELECT 1
        FROM menu
        WHERE
            codigo = 'CONFIG_USERS'
    );

-- Insert 'Roles' menu
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        orden,
        estado,
        parent_id
    )
SELECT 'Roles', '/settings/roles', 'ListIcon', 'CONFIG_ROLES', 2, 1, @parent_id
WHERE
    NOT EXISTS (
        SELECT 1
        FROM menu
        WHERE
            codigo = 'CONFIG_ROLES'
    );

-- Insert 'Permisos' menu
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        orden,
        estado,
        parent_id
    )
SELECT 'Permisos', '/settings/permissions', 'ShieldCheckIcon', 'CONFIG_PERMISSIONS', 3, 1, @parent_id
WHERE
    NOT EXISTS (
        SELECT 1
        FROM menu
        WHERE
            codigo = 'CONFIG_PERMISSIONS'
    );