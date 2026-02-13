-- Seed Configuration menus and permissions (V13_9)

-- 1. Insert 'Configuración' parent menu if it doesn't exist
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Configuración', NULL, 'PlugInIcon', NULL, 6, 1
WHERE
    NOT EXISTS (
        SELECT 1
        FROM menu
        WHERE
            nombre = 'Configuración'
    );

-- 2. Insert 'Ajustes' menu
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Ajustes', '/settings', 'PlugInIcon', NULL, 7, 1
WHERE
    NOT EXISTS (
        SELECT 1
        FROM menu
        WHERE
            ruta = '/settings'
    );

-- 3. Insert Children of 'Configuración' (Assuming 'Configuración' exists now)
-- We use a variable or subquery for parent_id
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        parent_id,
        orden,
        estado
    )
SELECT 'Usuarios', '/settings/users', NULL, m.id, 1, 1
FROM menu m
WHERE
    m.nombre = 'Configuración'
    AND m.parent_id IS NULL
    AND NOT EXISTS (
        SELECT 1
        FROM menu
        WHERE
            ruta = '/settings/users'
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
SELECT 'Roles', '/settings/roles', NULL, m.id, 2, 1
FROM menu m
WHERE
    m.nombre = 'Configuración'
    AND m.parent_id IS NULL
    AND NOT EXISTS (
        SELECT 1
        FROM menu
        WHERE
            ruta = '/settings/roles'
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
SELECT 'Permisos', '/settings/permissions', NULL, m.id, 3, 1
FROM menu m
WHERE
    m.nombre = 'Configuración'
    AND m.parent_id IS NULL
    AND NOT EXISTS (
        SELECT 1
        FROM menu
        WHERE
            ruta = '/settings/permissions'
    );

-- 4. Insert Permissions (if not exist)
INSERT INTO
    permiso (accion, recurso, descripcion)
SELECT 'LEER', 'USUARIOS', 'Ver usuarios'
WHERE
    NOT EXISTS (
        SELECT 1
        FROM permiso
        WHERE
            recurso = 'USUARIOS'
            AND accion = 'LEER'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
SELECT 'LEER', 'ROLES', 'Ver roles'
WHERE
    NOT EXISTS (
        SELECT 1
        FROM permiso
        WHERE
            recurso = 'ROLES'
            AND accion = 'LEER'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
SELECT 'LEER', 'PERMISOS', 'Ver permisos'
WHERE
    NOT EXISTS (
        SELECT 1
        FROM permiso
        WHERE
            recurso = 'PERMISOS'
            AND accion = 'LEER'
    );

INSERT INTO
    permiso (accion, recurso, descripcion)
SELECT 'LEER', 'AJUSTES', 'Ver ajustes'
WHERE
    NOT EXISTS (
        SELECT 1
        FROM permiso
        WHERE
            recurso = 'AJUSTES'
            AND accion = 'LEER'
    );

-- 5. Link Menus to Permissions
-- Configuración -> CONFIGURACION:LEER (Created in V13_8)
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.nombre = 'Configuración'
    AND p.recurso = 'CONFIGURACION'
    AND p.accion = 'LEER'
    AND NOT EXISTS (
        SELECT 1
        FROM asignacion_menu_permiso amp
        WHERE
            amp.menu_id = m.id
            AND amp.permiso_id = p.id
    );

-- Usuarios -> USUARIOS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/settings/users'
    AND p.recurso = 'USUARIOS'
    AND p.accion = 'LEER'
    AND NOT EXISTS (
        SELECT 1
        FROM asignacion_menu_permiso amp
        WHERE
            amp.menu_id = m.id
            AND amp.permiso_id = p.id
    );

-- Roles -> ROLES:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/settings/roles'
    AND p.recurso = 'ROLES'
    AND p.accion = 'LEER'
    AND NOT EXISTS (
        SELECT 1
        FROM asignacion_menu_permiso amp
        WHERE
            amp.menu_id = m.id
            AND amp.permiso_id = p.id
    );

-- Permisos -> PERMISOS:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/settings/permissions'
    AND p.recurso = 'PERMISOS'
    AND p.accion = 'LEER'
    AND NOT EXISTS (
        SELECT 1
        FROM asignacion_menu_permiso amp
        WHERE
            amp.menu_id = m.id
            AND amp.permiso_id = p.id
    );

-- Ajustes -> AJUSTES:LEER
INSERT INTO
    asignacion_menu_permiso (menu_id, permiso_id)
SELECT m.id, p.id
FROM menu m, permiso p
WHERE
    m.ruta = '/settings'
    AND p.recurso = 'AJUSTES'
    AND p.accion = 'LEER'
    AND NOT EXISTS (
        SELECT 1
        FROM asignacion_menu_permiso amp
        WHERE
            amp.menu_id = m.id
            AND amp.permiso_id = p.id
    );

-- 6. Assign NEW permissions to ADMIN (CONFIGURACION was assigned in V13_8)
INSERT INTO
    asignacion_rol_permiso (rol_id, permiso_id)
SELECT r.role_id, p.id
FROM roles r, permiso p
WHERE
    r.authority = 'ADMIN'
    AND p.recurso IN (
        'USUARIOS',
        'ROLES',
        'PERMISOS',
        'AJUSTES'
    )
    AND NOT EXISTS (
        SELECT 1
        FROM asignacion_rol_permiso arp
        WHERE
            arp.rol_id = r.role_id
            AND arp.permiso_id = p.id
    );