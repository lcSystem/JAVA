-- Migration Script for RBAC

-- 1. Create permissions tables
CREATE TABLE IF NOT EXISTS `roles` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `description` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `modules` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL UNIQUE,
    `description` VARCHAR(255) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `role_modules` (
    `role_id` INT(11) NOT NULL,
    `module_id` INT(11) NOT NULL,
    PRIMARY KEY (`role_id`, `module_id`),
    FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
    FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- 2. Populate basic roles and modules
INSERT IGNORE INTO
    `roles` (`id`, `name`, `description`)
VALUES (
        1,
        'Administrador',
        'Acceso total al sistema'
    ),
    (
        2,
        'Usuario',
        'Acceso limitado (Ej: Estilista)'
    ),
    (
        3,
        'Cliente',
        'Acceso solo lectura'
    );

INSERT IGNORE INTO
    `modules` (`id`, `name`, `description`)
VALUES (
        1,
        'Agenda',
        'Gestión de citas'
    ),
    (
        2,
        'Clientes',
        'Gestión de clientes'
    ),
    (
        3,
        'Ventas',
        'Gestión de ventas y facturación'
    ),
    (
        4,
        'Servicios',
        'Gestión de catálogo de servicios'
    ),
    (
        5,
        'Inventario',
        'Gestión de productos y stock'
    ),
    (
        6,
        'Empleados',
        'Gestión de personal y nómina'
    ),
    (
        7,
        'Reportes',
        'Visualización de reportes y KPIs'
    ),
    (
        8,
        'Configuración',
        'Ajustes del sistema y roles'
    );

-- 3. Assign modules to roles (Admin gets all)
INSERT IGNORE INTO
    `role_modules` (`role_id`, `module_id`)
VALUES (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (2, 1),
    (2, 2),
    (2, 4), -- Default employee access
    (3, 1),
    (3, 4);
-- Default customer access

-- 4. Alter users table to use role_id instead of ENUM role
-- Temporary column for transition (we don't want to lose data or clash types)
ALTER TABLE `users` ADD COLUMN `role_id` INT(11) DEFAULT NULL;

-- Migrate existing ENUM string to proper role IDs
UPDATE `users`
SET
    `role_id` = 1
WHERE
    `role` = 'ADMIN'
    OR `role` = 'admin';

UPDATE `users`
SET
    `role_id` = 2
WHERE
    `role` = 'EMPLOYEE'
    OR `role` = 'usuario';

UPDATE `users`
SET
    `role_id` = 3
WHERE
    `role` = 'CUSTOMER'
    OR `role` = 'cliente';

-- For safety, assign to default 'Usuario' if null
UPDATE `users` SET `role_id` = 2 WHERE `role_id` IS NULL;

-- Drop constraints if necessary, then drop old role enum
ALTER TABLE `users` DROP COLUMN `role`;

-- Rename role_id to role so we break minimal frontend code where possible?
-- The prompt specifies "role_id (INT, FK)". We should use role_id.
ALTER TABLE `users`
ADD CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);