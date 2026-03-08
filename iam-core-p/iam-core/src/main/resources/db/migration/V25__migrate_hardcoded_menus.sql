-- ============================================================
-- V25: Migrate hardcoded menus (Clientes, Conocer) to database
-- ============================================================

-- Add "Clientes" main menu
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
VALUES (
        'Clientes',
        '/customers',
        'GroupIcon',
        'CUSTOMERS',
        NULL,
        7,
        1
    );

SET @customers_id = LAST_INSERT_ID();

-- Add sub-menus for Clientes
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
VALUES (
        'Listado General',
        '/customers',
        'ListIcon',
        'CUSTOMERS_LIST',
        @customers_id,
        1,
        1
    ),
    (
        'Expedientes',
        '/customers/files',
        'FolderIcon',
        'CUSTOMERS_FILES',
        @customers_id,
        2,
        1
    ),
    (
        'Auditoría',
        '/customers/history',
        'TimeIcon',
        'CUSTOMERS_AUDIT',
        @customers_id,
        3,
        1
    );

-- Add "Conocer" (Tutorial) menu
INSERT INTO
    menu (
        nombre,
        ruta,
        icono,
        codigo,
        parent_id,
        orden,
        estado
    )
VALUES (
        'Conocer',
        '/conocer',
        'ListIcon',
        'CONOCER',
        NULL,
        8,
        1
    );

-- Grant ADMIN full access to these new menus in role_menu_permission
-- Assuming role_id 1 is ADMIN
INSERT INTO
    role_menu_permission (
        role_id,
        menu_id,
        can_read,
        can_create,
        can_update,
        can_delete
    )
SELECT 1, id, 1, 1, 1, 1
FROM menu
WHERE
    codigo LIKE 'CUSTOMERS%'
    OR codigo = 'CONOCER';