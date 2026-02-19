-- ============================================================
-- V21: Seed Credit Module Menus and Permissions
-- ============================================================

-- Add "Créditos" main menu
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
        'Créditos',
        NULL,
        'CalculatorIcon',
        'CREDITOS',
        NULL,
        6,
        1
    );

SET @parent_id = LAST_INSERT_ID();

-- Add Credit Module sub-menus
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
        'Simulador',
        '/creditos/simulator',
        NULL,
        'CREDIT_SIM',
        @parent_id,
        1,
        1
    ),
    (
        'Mis Solicitudes',
        '/creditos/requests',
        NULL,
        'CREDIT_REQ',
        @parent_id,
        2,
        1
    ),
    (
        'Aprobaciones',
        '/creditos/approvals',
        NULL,
        'CREDIT_APP',
        @parent_id,
        3,
        1
    ),
    (
        'Cartera',
        '/creditos/portfolio',
        NULL,
        'CREDIT_PORT',
        @parent_id,
        4,
        1
    );

-- Grant ADMIN full access to these new menus in role_menu_permission
-- Assuming role_id 1 is ADMIN as per previous migrations
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
    codigo LIKE 'CREDIT%';