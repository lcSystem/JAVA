-- Add authentication columns to the existing customers table
-- These columns enable client login via document_number (cédula)

ALTER TABLE customers
ADD COLUMN IF NOT EXISTS password_hash VARCHAR(255) NULL,
ADD COLUMN IF NOT EXISTS last_login DATETIME NULL,
ADD COLUMN IF NOT EXISTS login_attempts INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS account_locked BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS lock_expires_at DATETIME NULL;

-- Index for faster login lookups
CREATE INDEX IF NOT EXISTS idx_customer_login ON customers (
    document_number,
    password_hash
);