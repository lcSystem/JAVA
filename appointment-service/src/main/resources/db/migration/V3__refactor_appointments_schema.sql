-- V3: Refactor schema for production ERP standards (Enterprise Refinement Level 10/10)

-- 1. Cleanup: Drop IAM tables from the appointment schema (Scheduling Domain only)
DROP TABLE IF EXISTS usuarios CASCADE;

DROP TABLE IF EXISTS rol CASCADE;

DROP TABLE IF EXISTS permiso CASCADE;

DROP TABLE IF EXISTS usuario_rol CASCADE;

DROP TABLE IF EXISTS asignacion_usuario_rol CASCADE;

DROP TABLE IF EXISTS asignacion_rol_permiso CASCADE;

DROP TABLE IF EXISTS asignacion_menu_permiso CASCADE;

-- 2. Safe rename of availabilities to availability
DO $$ 
BEGIN 
    IF EXISTS (SELECT FROM information_schema.tables WHERE table_schema = 'appointment' AND table_name = 'availabilities') THEN
        ALTER TABLE availabilities RENAME TO availability;
    END IF;
END $$;

-- 3. Refactor availability table
ALTER TABLE availability
ALTER COLUMN day_of_week TYPE INT USING day_of_week::INTEGER,
ADD COLUMN IF NOT EXISTS tenant_id UUID, -- Added for Multi-tenancy
ADD CONSTRAINT check_day_of_week CHECK (day_of_week BETWEEN 1 AND 7);

-- 4. Refactor appointments table
ALTER TABLE appointments
ALTER COLUMN status TYPE VARCHAR(20),
ALTER COLUMN type TYPE VARCHAR(20),
ALTER COLUMN updated_at
DROP DEFAULT,
ADD COLUMN IF NOT EXISTS tenant_id UUID, -- Added for Multi-tenancy
ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS timezone VARCHAR(50),
ADD COLUMN IF NOT EXISTS duration INT;

-- Constraints for appointments
ALTER TABLE appointments
ADD CONSTRAINT check_appointment_status CHECK (
    status IN (
        'PENDING',
        'CONFIRMED',
        'CANCELLED',
        'COMPLETED',
        'RESCHEDULED',
        'NO_SHOW'
    )
),
ADD CONSTRAINT check_appointment_type CHECK (
    type IN ('PRESENCIAL', 'VIRTUAL')
),
ADD CONSTRAINT check_temporal_integrity CHECK (end_time > start_time),
ADD CONSTRAINT check_duration_positive CHECK (duration > 0);
-- REMOVED: CHECK (start_time >= CURRENT_TIMESTAMP) to allow historical data

-- 5. Audit robusta (Logical FK and indices)
ALTER TABLE appointment_audit
ADD COLUMN IF NOT EXISTS tenant_id UUID;

CREATE INDEX IF NOT EXISTS idx_appointment_audit_appointment_id ON appointment_audit (appointment_id);

CREATE INDEX IF NOT EXISTS idx_appointment_audit_tenant_id ON appointment_audit (tenant_id);

-- 6. Indices seguros e inteligentes (Multi-tenant + Soft Delete)
DROP INDEX IF EXISTS idx_appointments_employee_start;

DROP INDEX IF EXISTS idx_appointments_branch_start;

DROP INDEX IF EXISTS idx_appointments_customer;

DROP INDEX IF EXISTS idx_appointment_employee_time;

DROP INDEX IF EXISTS idx_appointment_branch_time;

DROP INDEX IF EXISTS idx_appointment_customer;

CREATE INDEX idx_appointments_active_employee_time ON appointments (
    tenant_id,
    employee_id,
    start_time
)
WHERE (is_deleted = FALSE);

CREATE INDEX idx_appointments_active_branch_time ON appointments (
    tenant_id,
    branch_id,
    start_time
)
WHERE (is_deleted = FALSE);

CREATE INDEX idx_appointments_active_customer ON appointments (tenant_id, customer_id)
WHERE (is_deleted = FALSE);

-- Availability index
CREATE INDEX idx_availability_tenant_employee ON availability (tenant_id, employee_id);

-- 7. Overlap constraint (Multi-tenant + Soft Delete)
ALTER TABLE appointments
DROP CONSTRAINT IF EXISTS no_overlap_appointments;

ALTER TABLE appointments
ADD CONSTRAINT no_overlap_appointments EXCLUDE USING gist (
    tenant_id
    WITH
        =, -- Isolated by tenant
        employee_id
    WITH
        =,
        tsrange (start_time, end_time)
    WITH
        &&
)
WHERE (
        status IN ('PENDING', 'CONFIRMED')
        AND is_deleted = FALSE
    );