-- Add extra fields to credit_requests for co-debtor, representative and additional debtor info
ALTER TABLE credit_requests
ADD COLUMN co_debtor_name VARCHAR(255),
ADD COLUMN co_debtor_id VARCHAR(50),
ADD COLUMN representative_name VARCHAR(255),
ADD COLUMN representative_id VARCHAR(50),
ADD COLUMN debtor_additional_info TEXT;