-- Migration to add descriptive name field in Spanish for parameters
ALTER TABLE parameter ADD COLUMN name VARCHAR(255) AFTER id;

-- Update existing records with the key as name if they don't have one
UPDATE parameter SET name = param_key WHERE name IS NULL;