-- =====================================================
-- V6: Complete Database Alignment with JPA Entities
-- =====================================================
-- Esta migración corrige tipos de datos y agrega columnas FK.
-- NO crea los constraints de FK aún - eso se hace en V10.
-- =====================================================

-- =====================================================
-- PARTE 1: Corrección de Tipos de IDs (INT → BIGINT)
-- =====================================================

-- 1.1 Tabla holiday
ALTER TABLE holiday MODIFY COLUMN HolidayId BIGINT AUTO_INCREMENT;

-- 1.2 Tabla LeaveType
ALTER TABLE LeaveType
MODIFY COLUMN leaveTypeId BIGINT AUTO_INCREMENT;

-- 1.3 Tabla Leaves
ALTER TABLE Leaves MODIFY COLUMN leavesID BIGINT AUTO_INCREMENT;

-- 1.4 Tabla estimates_invoices
ALTER TABLE estimates_invoices
MODIFY COLUMN id BIGINT AUTO_INCREMENT;

-- 1.5 Tabla item
ALTER TABLE item MODIFY COLUMN itemID BIGINT AUTO_INCREMENT;

-- 1.6 Tabla expenses
ALTER TABLE expenses MODIFY COLUMN Id BIGINT AUTO_INCREMENT;

-- =====================================================
-- PARTE 2: Corrección de Tipos de Fechas (VARCHAR → DATE)
-- =====================================================

-- 2.1 Tabla client
ALTER TABLE client MODIFY COLUMN date_Creation DATE;

-- 2.2 Tabla holiday
ALTER TABLE holiday
MODIFY COLUMN holidayDate DATE,
MODIFY COLUMN holidayDateEnd DATE;

-- 2.3 Tabla employees
ALTER TABLE employees
MODIFY COLUMN joinDate DATE,
MODIFY COLUMN birthday DATE;

-- 2.4 Tabla estimates_invoices
ALTER TABLE estimates_invoices
MODIFY COLUMN createDate DATE,
MODIFY COLUMN estimateDate DATE,
MODIFY COLUMN expiryDate DATE;

-- 2.5 Tabla payment
ALTER TABLE payment MODIFY COLUMN paidDate DATE;

-- 2.6 Tabla expenses
ALTER TABLE expenses MODIFY COLUMN purchase_date DATE;

-- 2.7 Tabla Leaves
ALTER TABLE Leaves
MODIFY COLUMN start_date DATE,
MODIFY COLUMN EndDate DATE;

-- 2.8 Tabla project
ALTER TABLE project
MODIFY COLUMN start_Date DATE,
MODIFY COLUMN end_Date DATE;

-- 2.9 Tabla task
ALTER TABLE task MODIFY COLUMN due_Date DATE;

-- =====================================================
-- PARTE 3: Corrección de Tipos de Datos Incorrectos
-- =====================================================

-- 3.1 Tabla expenses: Amount VARCHAR → DECIMAL
ALTER TABLE expenses MODIFY COLUMN Amount DECIMAL(19, 2);

-- 3.2 Tabla expenses: data LONGBLOB → TINYBLOB (para @Lob byte[])
ALTER TABLE expenses MODIFY COLUMN data TINYBLOB;

-- =====================================================
-- PARTE 4: Agregar columnas FK faltantes
-- =====================================================

-- 4.1 Tabla designation: agregar FK a department
ALTER TABLE designation ADD COLUMN department_id BIGINT;

-- 4.2 Tabla employees: agregar FKs a department y designation
ALTER TABLE employees ADD COLUMN department_id BIGINT;

ALTER TABLE employees ADD COLUMN designation_id BIGINT;

-- 4.3 Tabla Leaves: agregar FK a LeaveType
ALTER TABLE Leaves ADD COLUMN leave_type_id BIGINT;

-- =====================================================
-- PARTE 5: Corrección de columnas de referencia
-- =====================================================

-- 5.1 task: projectID VARCHAR → BIGINT
ALTER TABLE task MODIFY COLUMN projectID BIGINT;

-- 5.2 leaderProject: projectID, leaderID VARCHAR → BIGINT
ALTER TABLE leaderProject
MODIFY COLUMN projectID BIGINT,
MODIFY COLUMN leaderID BIGINT;

-- 5.3 employeeProject: projectID, employeeID VARCHAR → BIGINT
ALTER TABLE employeeProject
MODIFY COLUMN projectID BIGINT,
MODIFY COLUMN employeeID BIGINT;

-- 5.4 employeeTask: taskID, employeeID VARCHAR → BIGINT
ALTER TABLE employeeTask
MODIFY COLUMN taskID BIGINT,
MODIFY COLUMN employeeID BIGINT;

-- 5.5 fileProject: projectID VARCHAR → BIGINT
ALTER TABLE fileProject MODIFY COLUMN projectID BIGINT;

-- 5.6 imageProject: projectID VARCHAR → BIGINT
ALTER TABLE imageProject MODIFY COLUMN projectID BIGINT;

-- 5.7 messageTask: taskID, employeeID VARCHAR → BIGINT
ALTER TABLE messageTask
MODIFY COLUMN taskID BIGINT,
MODIFY COLUMN employeeID BIGINT;

-- 5.8 estimates_invoices: clientID, projectID INT → BIGINT
ALTER TABLE estimates_invoices
MODIFY COLUMN clientID BIGINT,
MODIFY COLUMN projectID BIGINT;

-- 5.9 item: estimate_invoices_id INT → BIGINT
ALTER TABLE item MODIFY COLUMN estimate_invoices_id BIGINT;

-- 5.10 payment: invoiceID BIGINT
ALTER TABLE payment MODIFY COLUMN invoiceID BIGINT;

-- =====================================================
-- PARTE 6: Eliminar columnas obsoletas
-- =====================================================

ALTER TABLE designation DROP COLUMN departmentName;

ALTER TABLE employees DROP COLUMN departement;

ALTER TABLE employees DROP COLUMN designation;

ALTER TABLE Leaves DROP COLUMN LeaveType;

-- =====================================================
-- FIN DE LA MIGRACIÓN V6
-- =====================================================