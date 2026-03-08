-- V3__add_contact_fields.sql
ALTER TABLE customer_contacts
ADD COLUMN IF NOT EXISTS document_number VARCHAR(50) AFTER phone,
ADD COLUMN IF NOT EXISTS birth_date DATE AFTER document_number,
ADD COLUMN IF NOT EXISTS is_legal_representative BOOLEAN DEFAULT FALSE AFTER birth_date;