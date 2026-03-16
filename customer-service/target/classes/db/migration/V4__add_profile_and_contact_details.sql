-- V4__add_profile_and_contact_details.sql
ALTER TABLE customers
ADD COLUMN IF NOT EXISTS birth_date DATE AFTER phone,
ADD COLUMN IF NOT EXISTS company_name VARCHAR(200) AFTER birth_date,
ADD COLUMN IF NOT EXISTS position VARCHAR(150) AFTER company_name,
ADD COLUMN IF NOT EXISTS work_phone VARCHAR(50) AFTER position,
ADD COLUMN IF NOT EXISTS corporate_email VARCHAR(150) AFTER work_phone,
ADD COLUMN IF NOT EXISTS salary DECIMAL(15, 2) AFTER corporate_email;

ALTER TABLE customer_contacts
ADD COLUMN IF NOT EXISTS company_name VARCHAR(200) AFTER position,
ADD COLUMN IF NOT EXISTS work_phone VARCHAR(50) AFTER company_name;