-- Migration to fix co_debtor_profiles relationship
ALTER TABLE co_debtor_profiles
ADD COLUMN credit_request_id BIGINT,
ADD FOREIGN KEY (credit_request_id) REFERENCES credit_requests (id);