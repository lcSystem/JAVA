-- V12__add_document_number_to_applicant.sql
ALTER TABLE applicant_profiles
ADD COLUMN document_number VARCHAR(50) AFTER user_id;

CREATE INDEX idx_applicant_document ON applicant_profiles (document_number);