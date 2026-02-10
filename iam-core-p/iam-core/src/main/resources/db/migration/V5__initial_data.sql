-- =====================================================
-- V5: Initial Data - Required for Application to Work
-- =====================================================

-- Roles por defecto (Spring Security los necesita)
-- Usando INSERT IGNORE para evitar duplicados
INSERT IGNORE INTO roles (role_id, authority) VALUES (1, 'ADMIN');

INSERT IGNORE INTO roles (role_id, authority) VALUES (2, 'USER');

-- Insertar usuario administrador por defecto (admin / admin)
-- El hash es BCrypt para 'admin'
INSERT IGNORE INTO
    users (userId, username, password)
VALUES (
        1,
        'admin',
        '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.TVuHOn2'
    );

-- Asignar el rol ADMIN (role_id 1) al usuario admin (userId 1)
INSERT IGNORE INTO
    user_role_junction (user_id, role_id)
VALUES (1, 1);