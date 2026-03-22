-- Enable btree_gist extension for overlap constraints
CREATE EXTENSION IF NOT EXISTS btree_gist;

-- Enums
DO $$ BEGIN
    CREATE TYPE appointment_status AS ENUM ('PENDING','CONFIRMED','CANCELLED','COMPLETED','RESCHEDULED','NO_SHOW');

EXCEPTION WHEN duplicate_object THEN null;

END $$;

DO $$ BEGIN
    CREATE TYPE appointment_type AS ENUM ('PRESENCIAL','VIRTUAL');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Appointments Table
CREATE TABLE IF NOT EXISTS appointments (
    id UUID PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    customer_id UUID NOT NULL,
    employee_id UUID NOT NULL,
    branch_id UUID NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL, -- Storing as string for JPA compatibility with existing Enums, or we could use the ENUM type
    type VARCHAR(50) NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    CONSTRAINT check_end_after_start CHECK (end_time > start_time)
);

-- Overlap constraint using GIST
-- This prevents the same employee from having overlapping appointments in PENDING or CONFIRMED status
ALTER TABLE appointments
ADD CONSTRAINT no_overlap_appointments EXCLUDE USING gist (
    employee_id
    WITH
        =,
        tsrange (start_time, end_time)
    WITH
        &&
)
WHERE (
        status IN ('PENDING', 'CONFIRMED')
    );

-- Availability Table
CREATE TABLE IF NOT EXISTS availabilities (
    id UUID PRIMARY KEY,
    employee_id UUID NOT NULL,
    branch_id UUID NOT NULL,
    day_of_week INT NOT NULL, -- 1=Monday, etc.
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Audit Table
CREATE TABLE IF NOT EXISTS appointment_audit (
    id UUID PRIMARY KEY,
    appointment_id UUID NOT NULL,
    action VARCHAR(50) NOT NULL, -- CREATE, UPDATE, CANCEL, RESCHEDULE
    old_status VARCHAR(20),
    new_status VARCHAR(20),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_appointments_employee_start ON appointments (employee_id, start_time);

CREATE INDEX IF NOT EXISTS idx_appointments_branch_start ON appointments (branch_id, start_time);

CREATE INDEX IF NOT EXISTS idx_appointments_customer ON appointments (customer_id);