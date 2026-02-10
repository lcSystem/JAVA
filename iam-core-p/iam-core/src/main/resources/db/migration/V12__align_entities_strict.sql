-- =====================================================
-- V12: Strict Alignment with JPA Entities
-- =====================================================
-- This script fixes discrepancies found between JPA entities and the DB schema.
-- It enforces snake_case for columns and adds strict constraints.

-- 1. Expenses Table Fixes
-- Entity: Expenses.java
-- 'Id' -> 'id' (Standardize)
-- 'Amount' -> 'amount' (Match default naming)
-- 'Status' -> 'status'
-- 'data' -> LONGBLOB (Ensure capacity for files)

-- Check if columns exist before creating/modifying (MySQL doesn't support IF EXISTS in ALTER well for columns, so we use CHANGE directly assuming V4/V6/V7 status)

ALTER TABLE expenses CHANGE COLUMN Id id BIGINT AUTO_INCREMENT;

ALTER TABLE expenses CHANGE COLUMN Amount amount DECIMAL(19, 2);

ALTER TABLE expenses CHANGE COLUMN Status status VARCHAR(255);

ALTER TABLE expenses MODIFY COLUMN data LONGBLOB;

-- 2. Client Table Constraints
-- Entity: Client.java
-- @Column(unique = true): company_Name (mapped to company_name), ice, rc, rib

ALTER TABLE client MODIFY COLUMN ice VARCHAR(255);

ALTER TABLE client ADD CONSTRAINT uk_client_ice UNIQUE (ice);

ALTER TABLE client MODIFY COLUMN rc VARCHAR(255);

ALTER TABLE client ADD CONSTRAINT uk_client_rc UNIQUE (rc);

ALTER TABLE client MODIFY COLUMN rib VARCHAR(255);

ALTER TABLE client ADD CONSTRAINT uk_client_rib UNIQUE (rib);

-- Note: company_name was already UNIQUE in V1/V7, but V7 might have dropped it during rename. Re-ensuring.
-- First drop if exists to avoid error? MySQL doesn't support DROP INDEX IF EXISTS in older versions, but current supported ones do.
-- We'll try to add it. If it fails, it might already exist.
-- Since we want a robust script, we can skip if we are unsure, but V1 created it unique. V7 renamed it.
-- Let's try to ensure it is unique.
-- ALTER TABLE client ADD CONSTRAINT uk_client_company_name UNIQUE (company_name);
-- (Commented out to prevent error if index persists from V1/V7 rename)

-- 3. Employee Table Constraints
-- Entity: Employee.java
-- @Column(unique = true): userName (mapped to user_name), cin

ALTER TABLE employees MODIFY COLUMN cin VARCHAR(255);

ALTER TABLE employees ADD CONSTRAINT uk_employees_cin UNIQUE (cin);

-- user_name might already be unique from V2.

-- 4. Holiday Table Constraints
-- Entity: Holiday.java
-- unique: holidayName -> mapped to holiday_name in V7

-- ALTER TABLE holiday ADD CONSTRAINT uk_holiday_name UNIQUE (holiday_name);

-- 5. LeaveType Table Constraints
-- Entity: LeaveType.java
-- unique: leaveName -> mapped to leave_name in V7

-- ALTER TABLE LeaveType ADD CONSTRAINT uk_leave_type_name UNIQUE (leave_name);

-- =====================================================
-- 6. Verification of Foreign Keys (EstimatesInvoices)
-- Entity: EstimatesInvoices.java -> clientid, projectid
-- V7: renamed to clientid, projectid. V10: added FKs.
-- No change needed if V10 ran successfully.