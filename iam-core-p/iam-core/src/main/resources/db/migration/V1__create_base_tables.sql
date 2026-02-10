-- =====================================================
-- V1: Base Tables (sin dependencias de FK)
-- =====================================================
-- Usando IF NOT EXISTS para compatibilidad con bases de datos existentes

-- Tabla de Roles (Spring Security)
CREATE TABLE IF NOT EXISTS roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    authority VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Departamentos
CREATE TABLE IF NOT EXISTS department (
    departmentID BIGINT AUTO_INCREMENT PRIMARY KEY,
    departmentName VARCHAR(255) UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Designaciones/Cargos
CREATE TABLE IF NOT EXISTS designation (
    designationID BIGINT AUTO_INCREMENT PRIMARY KEY,
    designationName VARCHAR(255) UNIQUE,
    departmentName VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Clientes
CREATE TABLE IF NOT EXISTS client (
    clientID BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_Name VARCHAR(255),
    last_Name VARCHAR(255),
    gender VARCHAR(255),
    designation VARCHAR(255),
    personnel_Email VARCHAR(255),
    personnel_Phone VARCHAR(255),
    imageName VARCHAR(255),
    company_Name VARCHAR(255) UNIQUE,
    date_Creation VARCHAR(255),
    address VARCHAR(255),
    ice VARCHAR(255) UNIQUE,
    rc VARCHAR(255) UNIQUE,
    ville VARCHAR(255),
    capital VARCHAR(255),
    rib VARCHAR(255) UNIQUE,
    company_Email VARCHAR(255),
    company_Phone VARCHAR(255),
    website VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Días Festivos
CREATE TABLE IF NOT EXISTS holiday (
    HolidayId INT AUTO_INCREMENT PRIMARY KEY,
    holidayName VARCHAR(255) UNIQUE,
    holidayDate VARCHAR(255),
    holidayDateEnd VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Tipos de Permisos
CREATE TABLE IF NOT EXISTS LeaveType (
    leaveTypeId INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255),
    leaveName VARCHAR(255) UNIQUE,
    days VARCHAR(255),
    leaveStatus VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
