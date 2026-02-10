-- =====================================================
-- V7: Rename Columns to Match Hibernate Naming Strategy
-- =====================================================
-- Se utiliza el naming exacto detectado en la generación automática:
-- Atributos intermedios -> snake_case (imageName -> image_name)
-- IDs finales -> lowercase sin guión (clientID -> clientid)
-- =====================================================

-- client
ALTER TABLE client
CHANGE COLUMN clientID clientid BIGINT AUTO_INCREMENT;

ALTER TABLE client CHANGE COLUMN first_Name first_name VARCHAR(255);

ALTER TABLE client CHANGE COLUMN last_Name last_name VARCHAR(255);

ALTER TABLE client
CHANGE COLUMN personnel_Email personnel_email VARCHAR(255);

ALTER TABLE client
CHANGE COLUMN personnel_Phone personnel_phone VARCHAR(255);

ALTER TABLE client CHANGE COLUMN imageName image_name VARCHAR(255);

ALTER TABLE client
CHANGE COLUMN company_Name company_name VARCHAR(255);

ALTER TABLE client CHANGE COLUMN date_Creation date_creation DATE;

ALTER TABLE client
CHANGE COLUMN company_Email company_email VARCHAR(255);

ALTER TABLE client
CHANGE COLUMN company_Phone company_phone VARCHAR(255);

-- employees
ALTER TABLE employees
CHANGE COLUMN employeeID employeeid BIGINT AUTO_INCREMENT;

ALTER TABLE employees
CHANGE COLUMN first_Name first_name VARCHAR(255);

ALTER TABLE employees CHANGE COLUMN last_Name last_name VARCHAR(255);

ALTER TABLE employees CHANGE COLUMN userName user_name VARCHAR(255);

ALTER TABLE employees CHANGE COLUMN joinDate join_date DATE;

ALTER TABLE employees
CHANGE COLUMN remainingLeaves remaining_leaves INT;

ALTER TABLE employees CHANGE COLUMN pinCode pin_code DOUBLE;

ALTER TABLE employees CHANGE COLUMN reportTo report_to VARCHAR(255);

ALTER TABLE employees
CHANGE COLUMN imageName image_name VARCHAR(255);

-- holiday
ALTER TABLE holiday
CHANGE COLUMN HolidayId holidayid BIGINT AUTO_INCREMENT;

ALTER TABLE holiday
CHANGE COLUMN holidayName holiday_name VARCHAR(255);

ALTER TABLE holiday CHANGE COLUMN holidayDate holiday_date DATE;

ALTER TABLE holiday
CHANGE COLUMN holidayDateEnd holiday_date_end DATE;

-- LeaveType
ALTER TABLE LeaveType
CHANGE COLUMN leaveTypeId leave_typeid BIGINT AUTO_INCREMENT;

ALTER TABLE LeaveType
CHANGE COLUMN leaveName leave_name VARCHAR(255);

ALTER TABLE LeaveType
CHANGE COLUMN leaveStatus leave_status VARCHAR(255);

-- Leaves
ALTER TABLE Leaves
CHANGE COLUMN leavesID leavesid BIGINT AUTO_INCREMENT;

ALTER TABLE Leaves
CHANGE COLUMN EmployeeName employee_name VARCHAR(255);

ALTER TABLE Leaves CHANGE COLUMN NumberOfDays number_of_days INT;

ALTER TABLE Leaves CHANGE COLUMN EndDate end_date DATE;

ALTER TABLE Leaves
CHANGE COLUMN LeaveReason leave_reason VARCHAR(255);

ALTER TABLE Leaves CHANGE COLUMN ApprovedBy approved_by VARCHAR(255);

ALTER TABLE Leaves CHANGE COLUMN Status status VARCHAR(255);

-- department
ALTER TABLE department
CHANGE COLUMN departmentID departmentid BIGINT AUTO_INCREMENT;

ALTER TABLE department
CHANGE COLUMN departmentName department_name VARCHAR(255);

-- designation
ALTER TABLE designation
CHANGE COLUMN designationID designationid BIGINT AUTO_INCREMENT;

ALTER TABLE designation
CHANGE COLUMN designationName designation_name VARCHAR(255);

-- project
ALTER TABLE project
CHANGE COLUMN projectID projectid BIGINT AUTO_INCREMENT;

ALTER TABLE project
CHANGE COLUMN project_Name project_name VARCHAR(255);

ALTER TABLE project
CHANGE COLUMN company_Name company_name VARCHAR(255);

ALTER TABLE project CHANGE COLUMN start_Date start_date DATE;

ALTER TABLE project CHANGE COLUMN end_Date end_date DATE;

ALTER TABLE project CHANGE COLUMN rate_Type rate_type VARCHAR(255);

ALTER TABLE project
CHANGE COLUMN total_Hours total_hours VARCHAR(255);

ALTER TABLE project CHANGE COLUMN created_By created_by VARCHAR(255);

-- estimates_invoices
ALTER TABLE estimates_invoices
CHANGE COLUMN createDate create_date DATE;

ALTER TABLE estimates_invoices
CHANGE COLUMN estimateDate estimate_date DATE;

ALTER TABLE estimates_invoices
CHANGE COLUMN expiryDate expiry_date DATE;

ALTER TABLE estimates_invoices
CHANGE COLUMN otherInfo other_info VARCHAR(255);

ALTER TABLE estimates_invoices
CHANGE COLUMN clientID clientid BIGINT;

ALTER TABLE estimates_invoices
CHANGE COLUMN projectID projectid BIGINT;

-- item
ALTER TABLE item CHANGE COLUMN itemID itemid BIGINT AUTO_INCREMENT;

ALTER TABLE item CHANGE COLUMN uniteCost unite_cost DOUBLE;

-- expenses
ALTER TABLE expenses CHANGE COLUMN itemName item_name VARCHAR(255);

ALTER TABLE expenses
CHANGE COLUMN purchaseFrom purchase_from VARCHAR(255);

ALTER TABLE expenses
CHANGE COLUMN purchasedBy purchased_by VARCHAR(255);

ALTER TABLE expenses CHANGE COLUMN paidBy paid_by VARCHAR(255);

ALTER TABLE expenses CHANGE COLUMN Status status VARCHAR(255);

-- payment
ALTER TABLE payment CHANGE COLUMN invoiceID invoiceid BIGINT;

ALTER TABLE payment CHANGE COLUMN paidDate paid_date DATE;

ALTER TABLE payment
CHANGE COLUMN paidAmount paid_amount DECIMAL(19, 2);

-- task
ALTER TABLE task CHANGE COLUMN taskID taskid BIGINT AUTO_INCREMENT;

ALTER TABLE task CHANGE COLUMN projectID projectid BIGINT;

ALTER TABLE task CHANGE COLUMN task_Name task_name VARCHAR(255);

ALTER TABLE task
CHANGE COLUMN task_Priority task_priority VARCHAR(255);

ALTER TABLE task CHANGE COLUMN due_Date due_date DATE;

-- leaderProject
ALTER TABLE leaderProject
CHANGE COLUMN leaderProjectID leader_projectid BIGINT AUTO_INCREMENT;

ALTER TABLE leaderProject CHANGE COLUMN projectID projectid BIGINT;

ALTER TABLE leaderProject CHANGE COLUMN leaderID leaderid BIGINT;

ALTER TABLE leaderProject
CHANGE COLUMN imageName image_name VARCHAR(255);

ALTER TABLE leaderProject
CHANGE COLUMN first_Name first_name VARCHAR(255);

ALTER TABLE leaderProject
CHANGE COLUMN last_Name last_name VARCHAR(255);

-- employeeProject
ALTER TABLE employeeProject
CHANGE COLUMN employeeProjectID employee_projectid BIGINT AUTO_INCREMENT;

ALTER TABLE employeeProject CHANGE COLUMN projectID projectid BIGINT;

ALTER TABLE employeeProject
CHANGE COLUMN employeeID employeeid BIGINT;

ALTER TABLE employeeProject
CHANGE COLUMN imageName image_name VARCHAR(255);

ALTER TABLE employeeProject
CHANGE COLUMN first_Name first_name VARCHAR(255);

ALTER TABLE employeeProject
CHANGE COLUMN last_Name last_name VARCHAR(255);

-- employeeTask
ALTER TABLE employeeTask
CHANGE COLUMN employeeTaskID employee_taskid BIGINT AUTO_INCREMENT;

ALTER TABLE employeeTask CHANGE COLUMN taskID taskid BIGINT;

ALTER TABLE employeeTask CHANGE COLUMN employeeID employeeid BIGINT;

ALTER TABLE employeeTask
CHANGE COLUMN imageName image_name VARCHAR(255);

ALTER TABLE employeeTask
CHANGE COLUMN first_Name first_name VARCHAR(255);

ALTER TABLE employeeTask
CHANGE COLUMN last_Name last_name VARCHAR(255);

-- fileProject
ALTER TABLE fileProject
CHANGE COLUMN fileProjectID file_projectid BIGINT AUTO_INCREMENT;

ALTER TABLE fileProject CHANGE COLUMN projectID projectid BIGINT;

ALTER TABLE fileProject
CHANGE COLUMN fileName file_name VARCHAR(255);

ALTER TABLE fileProject
CHANGE COLUMN originalName original_name VARCHAR(255);

ALTER TABLE fileProject
CHANGE COLUMN dateCreation date_creation VARCHAR(255);

-- imageProject
ALTER TABLE imageProject
CHANGE COLUMN imageProjectID image_projectid BIGINT AUTO_INCREMENT;

ALTER TABLE imageProject CHANGE COLUMN projectID projectid BIGINT;

ALTER TABLE imageProject
CHANGE COLUMN imageName image_name VARCHAR(255);

ALTER TABLE imageProject
CHANGE COLUMN originalName original_name VARCHAR(255);

-- messageTask
ALTER TABLE messageTask
CHANGE COLUMN messageTaskID message_taskid BIGINT AUTO_INCREMENT;

ALTER TABLE messageTask CHANGE COLUMN taskID taskid BIGINT;

ALTER TABLE messageTask CHANGE COLUMN employeeID employeeid BIGINT;

ALTER TABLE messageTask
CHANGE COLUMN imageName image_name VARCHAR(255);

ALTER TABLE messageTask
CHANGE COLUMN first_Name first_name VARCHAR(255);

ALTER TABLE messageTask
CHANGE COLUMN last_Name last_name VARCHAR(255);

-- users
ALTER TABLE users CHANGE COLUMN userId user_id INT AUTO_INCREMENT;

-- roles
ALTER TABLE roles CHANGE COLUMN role_id role_id INT;