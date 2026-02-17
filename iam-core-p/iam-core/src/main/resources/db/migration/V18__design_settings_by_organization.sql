-- Migrar app_design_settings de por-usuario a por-organización

-- 1. Agregar columna organizacion_id
ALTER TABLE app_design_settings ADD COLUMN organizacion_id BIGINT;

-- 2. Copiar el organizacion_id del usuario asociado
UPDATE app_design_settings ads
JOIN users u ON u.user_id = ads.user_id
SET
    ads.organizacion_id = u.organizacion_id;

-- 3. Eliminar FK y columna user_id
ALTER TABLE app_design_settings
DROP FOREIGN KEY app_design_settings_ibfk_1;

ALTER TABLE app_design_settings DROP COLUMN user_id;

-- 4. Agregar constraint UNIQUE para 1 config por organización
ALTER TABLE app_design_settings
ADD CONSTRAINT uq_design_org UNIQUE (organizacion_id);