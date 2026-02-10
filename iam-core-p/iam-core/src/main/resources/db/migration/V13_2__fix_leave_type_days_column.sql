-- V13_2: Fix leave_type.days column type
-- Change days from VARCHAR to INT to match Java entity
ALTER TABLE leave_type MODIFY COLUMN days INT NOT NULL;