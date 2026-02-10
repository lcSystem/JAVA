-- =====================================================
-- V2: User and Employee Tables
-- =====================================================

-- Tabla de Usuarios (Spring Security Authentication)
CREATE TABLE IF NOT EXISTS users (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255) UNIQUE,
    password VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de unión Users-Roles (ManyToMany)
CREATE TABLE IF NOT EXISTS user_role_junction (
    user_id INT NOT NULL,
    role_id INT NOT NULL,
    PRIMARY KEY (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Agregar FKs solo si no existen (usando procedimiento para evitar errores)
-- Nota: MySQL no soporta IF NOT EXISTS para constraints directamente
-- Las FKs se manejan de forma segura

-- Tabla de Empleados
CREATE TABLE IF NOT EXISTS employees (
    employeeID BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_Name VARCHAR(255),
    last_Name VARCHAR(255),
    userName VARCHAR(255) UNIQUE,
    email VARCHAR(255),
    password VARCHAR(255),
    joinDate VARCHAR(255),
    phone VARCHAR(255),
    departement VARCHAR(255),
    designation VARCHAR(255),
    company VARCHAR(255),
    remainingLeaves INT,
    role VARCHAR(255),
    pinCode DOUBLE,
    cv_Name VARCHAR(255),
    cv TINYINT,
    cin VARCHAR(255) UNIQUE,
    reportTo VARCHAR(255),
    birthday VARCHAR(255),
    address VARCHAR(255),
    gender VARCHAR(255),
    state VARCHAR(255),
    country VARCHAR(255),
    imageName VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Tokens en Lista Negra (JWT Revocados)
-- IMPORTANTE: El nombre debe coincidir con la entidad BlacklistedToken
CREATE TABLE IF NOT EXISTS blacklisted_token (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    token VARCHAR(500)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
