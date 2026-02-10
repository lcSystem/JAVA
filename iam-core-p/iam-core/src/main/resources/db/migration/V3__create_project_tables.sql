-- =====================================================
-- V3: Project Related Tables
-- =====================================================

-- Tabla de Proyectos
CREATE TABLE IF NOT EXISTS project (
    projectID BIGINT AUTO_INCREMENT PRIMARY KEY,
    project_Name VARCHAR(255),
    company_Name VARCHAR(255),
    start_Date VARCHAR(255),
    end_Date VARCHAR(255),
    rate VARCHAR(255),
    rate_Type VARCHAR(255),
    priority VARCHAR(255),
    total_Hours VARCHAR(255),
    status VARCHAR(255),
    created_By VARCHAR(255),
    description VARCHAR(1000),
    progress VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Tareas
CREATE TABLE IF NOT EXISTS task (
    taskID BIGINT AUTO_INCREMENT PRIMARY KEY,
    projectID VARCHAR(255),
    task_Name VARCHAR(255),
    task_Priority VARCHAR(255),
    due_Date VARCHAR(255),
    description VARCHAR(1000),
    status VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Líderes de Proyecto
CREATE TABLE IF NOT EXISTS leaderProject (
    leaderProjectID BIGINT AUTO_INCREMENT PRIMARY KEY,
    projectID VARCHAR(255),
    leaderID VARCHAR(255),
    first_Name VARCHAR(255),
    last_Name VARCHAR(255),
    designation VARCHAR(255),
    imageName VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Empleados en Proyectos
CREATE TABLE IF NOT EXISTS employeeProject (
    employeeProjectID BIGINT AUTO_INCREMENT PRIMARY KEY,
    projectID VARCHAR(255),
    employeeID VARCHAR(255),
    first_Name VARCHAR(255),
    last_Name VARCHAR(255),
    designation VARCHAR(255),
    imageName VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Empleados en Tareas
CREATE TABLE IF NOT EXISTS employeeTask (
    employeeTaskID BIGINT AUTO_INCREMENT PRIMARY KEY,
    taskID VARCHAR(255),
    employeeID VARCHAR(255),
    first_Name VARCHAR(255),
    last_Name VARCHAR(255),
    designation VARCHAR(255),
    imageName VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Archivos de Proyecto
CREATE TABLE IF NOT EXISTS fileProject (
    fileProjectID BIGINT AUTO_INCREMENT PRIMARY KEY,
    projectID VARCHAR(255),
    fileName VARCHAR(255),
    originalName VARCHAR(255),
    dateCreation VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Imágenes de Proyecto
CREATE TABLE IF NOT EXISTS imageProject (
    imageProjectID BIGINT AUTO_INCREMENT PRIMARY KEY,
    projectID VARCHAR(255),
    imageName VARCHAR(255),
    originalName VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Mensajes de Tarea
CREATE TABLE IF NOT EXISTS messageTask (
    messageTaskID BIGINT AUTO_INCREMENT PRIMARY KEY,
    taskID VARCHAR(255),
    employeeID VARCHAR(255),
    first_Name VARCHAR(255),
    last_Name VARCHAR(255),
    imageName VARCHAR(255),
    date VARCHAR(255),
    message VARCHAR(500)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
