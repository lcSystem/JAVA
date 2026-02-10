-- =====================================================
-- V13: Aggressive Schema Fix - Standardize IDs & FKs
-- =====================================================
-- Goal: Rename all ID columns to standard snake_case (e.g., clientid -> client_id)
-- and fix all inconsistencies to satisfy Hibernate validation.

-- 1. DROP EXISTING FOREIGN KEYS (Safe Cleanup)
-- We drop them by name (as created in V10).
-- If V10 didn't run or names differ, this might fail, but we assume V10 baseline.

ALTER TABLE designation DROP FOREIGN KEY fk_designation_department;

ALTER TABLE employees DROP FOREIGN KEY fk_employees_department;

ALTER TABLE employees DROP FOREIGN KEY fk_employees_designation;

ALTER TABLE leaves DROP FOREIGN KEY fk_leaves_leavetype;

ALTER TABLE estimates_invoices DROP FOREIGN KEY fk_estimates_client;

ALTER TABLE estimates_invoices DROP FOREIGN KEY fk_estimates_project;

ALTER TABLE item DROP FOREIGN KEY fk_item_estimates;

ALTER TABLE payment DROP FOREIGN KEY fk_payment_invoice;

ALTER TABLE task DROP FOREIGN KEY fk_task_project;

ALTER TABLE employee_project
DROP FOREIGN KEY fk_employeeproject_project;

ALTER TABLE employee_project
DROP FOREIGN KEY fk_employeeproject_employee;
-- User roles keys
ALTER TABLE user_role_junction DROP FOREIGN KEY fk_user_role_user;

ALTER TABLE user_role_junction DROP FOREIGN KEY fk_user_role_role;

-- 2. RENAME COLUMNS (Standardize to snake_case)

-- Department
ALTER TABLE department
CHANGE COLUMN departmentid department_id BIGINT AUTO_INCREMENT;

-- Designation
ALTER TABLE designation
CHANGE COLUMN designationid designation_id BIGINT AUTO_INCREMENT;
-- department_id already correct (from V6/V10), but let's double check V6 said `ADD COLUMN department_id`. Correct.

-- Client
ALTER TABLE client
CHANGE COLUMN clientid client_id BIGINT AUTO_INCREMENT;

-- Project
ALTER TABLE project
CHANGE COLUMN projectid project_id BIGINT AUTO_INCREMENT;

-- Employees
ALTER TABLE employees
CHANGE COLUMN employeeid employee_id BIGINT AUTO_INCREMENT;

-- Task
ALTER TABLE task CHANGE COLUMN taskid task_id BIGINT AUTO_INCREMENT;
-- task.projectid -> project_id
ALTER TABLE task CHANGE COLUMN projectid project_id BIGINT;

-- Leaves
ALTER TABLE leaves
CHANGE COLUMN leavesid leaves_id BIGINT AUTO_INCREMENT;
-- leaves.leave_type_id (V6 added this name, so it SHOULD be correct, but let's verify if V7 changed it? V7 touched LeaveType table, not Leaves column names for relations? V7 said `ALTER TABLE Leaves CHANGE COLUMN leavesID leavesid`... wait. did V7 rename FKs?
-- V7 didn't rename `leave_type_id` in `leaves` table. V6 added it.
-- However, V10 used `FOREIGN KEY (leave_type_id) REFERENCES leave_type (leave_typeid)`.
-- So `leaves.leave_type_id` is ALREADY snake_case. Good.

-- LeaveType
ALTER TABLE leave_type
CHANGE COLUMN leave_typeid leave_type_id BIGINT AUTO_INCREMENT;

-- EstimatesInvoices
ALTER TABLE estimates_invoices
CHANGE COLUMN clientid client_id BIGINT;

ALTER TABLE estimates_invoices
CHANGE COLUMN projectid project_id BIGINT;
-- id is already `id`.

-- Item
ALTER TABLE item CHANGE COLUMN itemid item_id BIGINT AUTO_INCREMENT;
-- estimate_invoices_id is already snake_case (V6).

-- Payment
ALTER TABLE payment CHANGE COLUMN invoiceid invoice_id BIGINT;

-- Roles (if needed, V7 said role_id was INT, V1 said AUTO_INCREMENT)
-- V7: `CHANGE COLUMN role_id role_id INT`.
-- Let's ensure it's correct.
-- ALTER TABLE roles CHANGE COLUMN role_id role_id INT AUTO_INCREMENT; -- (Assuming it's fine)

-- 3. RE-CREATE FOREIGN KEYS

-- designation -> department
ALTER TABLE designation
ADD CONSTRAINT fk_designation_department FOREIGN KEY (department_id) REFERENCES department (department_id) ON DELETE SET NULL;

-- employees -> department
ALTER TABLE employees
ADD CONSTRAINT fk_employees_department FOREIGN KEY (department_id) REFERENCES department (department_id) ON DELETE SET NULL;

-- employees -> designation
ALTER TABLE employees
ADD CONSTRAINT fk_employees_designation FOREIGN KEY (designation_id) REFERENCES designation (designation_id) ON DELETE SET NULL;

-- leaves -> leave_type
ALTER TABLE leaves
ADD CONSTRAINT fk_leaves_leavetype FOREIGN KEY (leave_type_id) REFERENCES leave_type (leave_type_id) ON DELETE SET NULL;

-- estimates_invoices -> client
ALTER TABLE estimates_invoices
ADD CONSTRAINT fk_estimates_client FOREIGN KEY (client_id) REFERENCES client (client_id) ON DELETE SET NULL;

-- estimates_invoices -> project
ALTER TABLE estimates_invoices
ADD CONSTRAINT fk_estimates_project FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE SET NULL;

-- item -> estimates_invoices
ALTER TABLE item
ADD CONSTRAINT fk_item_estimates FOREIGN KEY (estimate_invoices_id) REFERENCES estimates_invoices (id) ON DELETE CASCADE;

-- payment -> estimates_invoices
ALTER TABLE payment
ADD CONSTRAINT fk_payment_invoice FOREIGN KEY (invoice_id) REFERENCES estimates_invoices (id) ON DELETE CASCADE;

-- task -> project
ALTER TABLE task
ADD CONSTRAINT fk_task_project FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE;

-- employee_project -> project
ALTER TABLE employee_project
CHANGE COLUMN projectid project_id BIGINT;

ALTER TABLE employee_project
ADD CONSTRAINT fk_employeeproject_project FOREIGN KEY (project_id) REFERENCES project (project_id) ON DELETE CASCADE;

-- employee_project -> employees
ALTER TABLE employee_project
CHANGE COLUMN employeeid employee_id BIGINT;

ALTER TABLE employee_project
ADD CONSTRAINT fk_employeeproject_employee FOREIGN KEY (employee_id) REFERENCES employees (employee_id) ON DELETE CASCADE;

-- user_role_junction keys (names seem standard, just re-adding)
ALTER TABLE user_role_junction
ADD CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE;

ALTER TABLE user_role_junction
ADD CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE;

-- Additional: Update other tables with FK-like columns that were renamed in V7 but might need underscore
-- employee_task, message_task, leader_project, file_project, image_project

-- employee_task
ALTER TABLE employee_task CHANGE COLUMN taskid task_id BIGINT;

ALTER TABLE employee_task
CHANGE COLUMN employeeid employee_id BIGINT;

ALTER TABLE employee_task
CHANGE COLUMN employee_taskid employee_task_id BIGINT AUTO_INCREMENT;

-- message_task
ALTER TABLE message_task CHANGE COLUMN taskid task_id BIGINT;

ALTER TABLE message_task CHANGE COLUMN employeeid employee_id BIGINT;

ALTER TABLE message_task
CHANGE COLUMN message_taskid message_task_id BIGINT AUTO_INCREMENT;

-- leader_project
ALTER TABLE leader_project CHANGE COLUMN projectid project_id BIGINT;

ALTER TABLE leader_project CHANGE COLUMN leaderid leader_id BIGINT;

ALTER TABLE leader_project
CHANGE COLUMN leader_projectid leader_project_id BIGINT AUTO_INCREMENT;

-- file_project
ALTER TABLE file_project CHANGE COLUMN projectid project_id BIGINT;

ALTER TABLE file_project
CHANGE COLUMN file_projectid file_project_id BIGINT AUTO_INCREMENT;

-- image_project
ALTER TABLE image_project CHANGE COLUMN projectid project_id BIGINT;

ALTER TABLE image_project
CHANGE COLUMN image_projectid image_project_id BIGINT AUTO_INCREMENT;