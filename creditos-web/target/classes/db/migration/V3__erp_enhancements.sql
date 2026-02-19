-- 1. Eliminar tabla redundante
DROP TABLE IF EXISTS credits;

-- 2. Integridad Referencial faltante
ALTER TABLE credit_requests
ADD CONSTRAINT fk_credit_request_applicant FOREIGN KEY (applicant_id) REFERENCES applicant_profiles (id);

-- 3. Indices para rendimiento
CREATE INDEX idx_credit_requests_applicant ON credit_requests (applicant_id);

CREATE INDEX idx_credit_requests_status ON credit_requests (status);

CREATE INDEX idx_amortization_request ON amortization_schedule (request_id);

CREATE INDEX idx_payments_installment ON payments (installment_id);

-- 4. Restricciones Unicas
ALTER TABLE credit_types
ADD CONSTRAINT uq_credit_type_name UNIQUE (name);

ALTER TABLE amortization_schedule
ADD CONSTRAINT uq_amortization_req_installment UNIQUE (
    request_id,
    installment_number
);

-- 5. Agregar columnas de Auditoría, Versionado y Soft Delete a todas las tablas principales

-- credit_types
ALTER TABLE credit_types
ADD COLUMN version BIGINT DEFAULT 0 NOT NULL,
ADD COLUMN created_by VARCHAR(100),
ADD COLUMN updated_by VARCHAR(100),
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN deleted_at TIMESTAMP NULL;

-- applicant_profiles
ALTER TABLE applicant_profiles
ADD COLUMN version BIGINT DEFAULT 0 NOT NULL,
ADD COLUMN created_by VARCHAR(100),
ADD COLUMN updated_by VARCHAR(100),
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN deleted_at TIMESTAMP NULL;
-- (updated_at ya existía en V2, pero aseguramos consistencia si hiciera falta, aunque V2 ya lo tenía)

-- credit_requests
ALTER TABLE credit_requests
ADD COLUMN version BIGINT DEFAULT 0 NOT NULL,
ADD COLUMN created_by VARCHAR(100),
ADD COLUMN updated_by VARCHAR(100),
ADD COLUMN deleted_at TIMESTAMP NULL;
-- (created_at y updated_at ya existían en V2)

-- approval_audit
ALTER TABLE approval_audit
ADD COLUMN version BIGINT DEFAULT 0 NOT NULL,
ADD COLUMN created_by VARCHAR(100), -- Puede ser redundante con approver_username, pero mantenemos estándar
ADD COLUMN updated_by VARCHAR(100),
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN deleted_at TIMESTAMP NULL;

-- amortization_schedule
ALTER TABLE amortization_schedule
ADD COLUMN version BIGINT DEFAULT 0 NOT NULL,
ADD COLUMN created_by VARCHAR(100),
ADD COLUMN updated_by VARCHAR(100),
ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN deleted_at TIMESTAMP NULL;

-- payments
ALTER TABLE payments
ADD COLUMN version BIGINT DEFAULT 0 NOT NULL,
ADD COLUMN created_by VARCHAR(100),
ADD COLUMN updated_by VARCHAR(100),
ADD COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD COLUMN deleted_at TIMESTAMP NULL;
-- (payment_date actua como created_at)

-- 6. Validaciones de Integridad (Check Constraints)
-- Nota: MySQL soporta CHECK constraints desde 8.0.16. Si es una versión anterior, serán ignorados pero no fallará.

ALTER TABLE credit_requests
ADD CONSTRAINT chk_credit_amount_positive CHECK (amount > 0),
ADD CONSTRAINT chk_credit_term_positive CHECK (term_months > 0);

ALTER TABLE credit_types
ADD CONSTRAINT chk_type_amounts CHECK (
    min_amount > 0
    AND max_amount >= min_amount
),
ADD CONSTRAINT chk_type_terms CHECK (
    min_term_months > 0
    AND max_term_months >= min_term_months
);

ALTER TABLE amortization_schedule
ADD CONSTRAINT chk_amort_principal_positive CHECK (principal_amount >= 0),
ADD CONSTRAINT chk_amort_interest_positive CHECK (interest_amount >= 0),
ADD CONSTRAINT chk_amort_total_positive CHECK (total_installment >= 0);

ALTER TABLE payments
ADD CONSTRAINT chk_payment_amount_positive CHECK (amount_paid > 0);