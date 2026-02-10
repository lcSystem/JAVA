-- =====================================================
-- V4: Financial Tables
-- =====================================================

-- Tabla de Estimados e Invoices
CREATE TABLE IF NOT EXISTS estimates_invoices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(255),
    clientID INT,
    projectID INT,
    createDate VARCHAR(255),
    estimateDate VARCHAR(255),
    expiryDate VARCHAR(255),
    total DECIMAL(19,2),
    otherInfo VARCHAR(255),
    status VARCHAR(255),
    tax INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Items (con relación a estimates_invoices)
CREATE TABLE IF NOT EXISTS item (
    itemID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    description VARCHAR(255),
    uniteCost DOUBLE,
    quantity INT,
    amount DOUBLE,
    estimate_invoices_id INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Pagos
CREATE TABLE IF NOT EXISTS payment (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    invoiceID BIGINT,
    paidDate VARCHAR(255),
    paidAmount DECIMAL(19,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Gastos
CREATE TABLE IF NOT EXISTS expenses (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    itemName VARCHAR(255),
    purchaseFrom VARCHAR(255),
    purchase_date VARCHAR(255),
    purchasedBy VARCHAR(255),
    Amount VARCHAR(255),
    paidBy VARCHAR(255),
    Status VARCHAR(255),
    data LONGBLOB
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabla de Permisos/Vacaciones
CREATE TABLE IF NOT EXISTS Leaves (
    leavesID INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(255),
    EmployeeName VARCHAR(255),
    LeaveType VARCHAR(255),
    NumberOfDays INT,
    start_date VARCHAR(255),
    EndDate VARCHAR(255),
    LeaveReason VARCHAR(255),
    ApprovedBy VARCHAR(255),
    Status VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
