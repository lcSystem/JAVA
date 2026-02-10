-- =====================================================
-- V10: Create Foreign Key Constraints
-- =====================================================

-- designation → department
ALTER TABLE designation
ADD CONSTRAINT fk_designation_department FOREIGN KEY (department_id) REFERENCES department (departmentid) ON DELETE SET NULL;

-- employees → department
ALTER TABLE employees
ADD CONSTRAINT fk_employees_department FOREIGN KEY (department_id) REFERENCES department (departmentid) ON DELETE SET NULL;

-- employees → designation
ALTER TABLE employees
ADD CONSTRAINT fk_employees_designation FOREIGN KEY (designation_id) REFERENCES designation (designationid) ON DELETE SET NULL;

-- leaves → leave_type
ALTER TABLE leaves
ADD CONSTRAINT fk_leaves_leavetype FOREIGN KEY (leave_type_id) REFERENCES leave_type (leave_typeid) ON DELETE SET NULL;

-- estimates_invoices → client
ALTER TABLE estimates_invoices
ADD CONSTRAINT fk_estimates_client FOREIGN KEY (clientid) REFERENCES client (clientid) ON DELETE SET NULL;

-- estimates_invoices → project
ALTER TABLE estimates_invoices
ADD CONSTRAINT fk_estimates_project FOREIGN KEY (projectid) REFERENCES project (projectid) ON DELETE SET NULL;

-- item → estimates_invoices
ALTER TABLE item
ADD CONSTRAINT fk_item_estimates FOREIGN KEY (estimate_invoices_id) REFERENCES estimates_invoices (id) ON DELETE CASCADE;

-- payment → estimates_invoices
ALTER TABLE payment
ADD CONSTRAINT fk_payment_invoice FOREIGN KEY (invoiceid) REFERENCES estimates_invoices (id) ON DELETE CASCADE;

-- task → project
ALTER TABLE task
ADD CONSTRAINT fk_task_project FOREIGN KEY (projectid) REFERENCES project (projectid) ON DELETE CASCADE;

-- employee_project → project
ALTER TABLE employee_project
ADD CONSTRAINT fk_employeeproject_project FOREIGN KEY (projectid) REFERENCES project (projectid) ON DELETE CASCADE;

-- employee_project → employees
ALTER TABLE employee_project
ADD CONSTRAINT fk_employeeproject_employee FOREIGN KEY (employeeid) REFERENCES employees (employeeid) ON DELETE CASCADE;

-- user_role_junction → users
ALTER TABLE user_role_junction
ADD CONSTRAINT fk_user_role_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE;

-- user_role_junction → roles
ALTER TABLE user_role_junction
ADD CONSTRAINT fk_user_role_role FOREIGN KEY (role_id) REFERENCES roles (role_id) ON DELETE CASCADE;

-- =====================================================
-- FIN DE LA MIGRACIÓN V10
-- =====================================================