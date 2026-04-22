-- REPARACIÓN FINAL DE MÓDULOS Y ROLES
-- Asegura que no falte ningún ID de módulo y que el Admin tenga todo.

-- 1. Asegurar módulos críticos
INSERT IGNORE INTO
    `modules` (`id`, `name`)
VALUES (1, 'Agenda'),
    (2, 'Clientes'),
    (3, 'Ventas'),
    (4, 'Servicios'),
    (5, 'Inventario'),
    (6, 'Empleados'),
    (7, 'Reportes'),
    (8, 'Configuración'),
    (9, 'Roles y Permisos'),
    (10, 'Usuarios'),
    (11, 'Monitoreo'),
    (12, 'Mi Perfil'),
    (13, 'Historial'),
    (14, 'Home');

-- 2. Asegurar Roles
INSERT IGNORE INTO
    `roles` (`id`, `name`)
VALUES (1, 'Administrador');

-- 3. Asignar TODO al Administrador (ID 1)
-- Borramos primero para reconstruir limpio
DELETE FROM `role_modules` WHERE `role_id` = 1;

INSERT INTO
    `role_modules` (`role_id`, `module_id`)
VALUES (1, 1),
    (1, 2),
    (1, 3),
    (1, 4),
    (1, 5),
    (1, 6),
    (1, 7),
    (1, 8),
    (1, 9),
    (1, 10),
    (1, 11),
    (1, 12),
    (1, 13),
    (1, 14);

-- 4. Asegurar que tu usuario sea Admin
UPDATE `users` SET `role_id` = 1 WHERE `username` = 'admin';

UPDATE `users` SET `role_id` = 1 WHERE `username` = 'estefany';