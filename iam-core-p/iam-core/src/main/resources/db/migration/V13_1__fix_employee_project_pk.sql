-- V13_1: Fix missing PK rename in employee_project
-- Source column is employee_projectid (from V7), renaming to employee_project_id
ALTER TABLE employee_project
CHANGE COLUMN employee_projectid employee_project_id BIGINT AUTO_INCREMENT;