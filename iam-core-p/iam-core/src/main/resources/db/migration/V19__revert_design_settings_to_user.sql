-- Revert: restore user_id column to app_design_settings

-- 1. Add user_id column back
ALTER TABLE app_design_settings ADD COLUMN user_id INT;

-- 2. Add foreign key
ALTER TABLE app_design_settings
ADD CONSTRAINT fk_design_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE;

-- 3. Drop the organizacion_id column and constraint
ALTER TABLE app_design_settings DROP INDEX uq_design_org;

ALTER TABLE app_design_settings DROP COLUMN organizacion_id;