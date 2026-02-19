-- Add missing description column to credit_types
ALTER TABLE credit_types
ADD COLUMN description VARCHAR(500) AFTER name;