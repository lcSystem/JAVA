-- Migration v2: Add missing modules and assign them to Admin role

-- Add new modules
INSERT IGNORE INTO
    `modules` (`id`, `name`, `description`)
VALUES (
        9,
        'Roles y Permisos',
        'Gestión de roles y control de acceso'
    ),
    (
        10,
        'Usuarios',
        'Gestión de usuarios del sistema'
    );

-- Assign new modules to Admin role (role_id = 1)
INSERT IGNORE INTO
    `role_modules` (`role_id`, `module_id`)
VALUES (1, 9),
    (1, 10);