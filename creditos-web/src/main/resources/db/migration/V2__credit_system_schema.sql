-- Tipos de crédito (Configuración)
CREATE TABLE IF NOT EXISTS credit_types (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    min_amount DECIMAL(19, 2) NOT NULL,
    max_amount DECIMAL(19, 2) NOT NULL,
    min_term_months INT NOT NULL,
    max_term_months INT NOT NULL,
    annual_interest_rate DECIMAL(5, 2) NOT NULL,
    policy_description TEXT,
    active BOOLEAN DEFAULT TRUE
);

-- Perfiles de solicitantes (Carga financiera)
CREATE TABLE IF NOT EXISTS applicant_profiles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL, -- ID del usuario en iam-core (referencia lógica)
    monthly_income DECIMAL(19, 2) NOT NULL,
    monthly_expenses DECIMAL(19, 2) NOT NULL,
    current_debts DECIMAL(19, 2) NOT NULL,
    credit_score INT,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Solicitudes de crédito
CREATE TABLE IF NOT EXISTS credit_requests (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    applicant_id BIGINT NOT NULL,
    credit_type_id BIGINT NOT NULL,
    amount DECIMAL(19, 2) NOT NULL,
    term_months INT NOT NULL,
    purpose TEXT,
    status VARCHAR(50) NOT NULL, -- DRAFT, EVALUATING, APPROVED, REJECTED, DISBURSED
    scoring_result VARCHAR(50),
    scoring_recommendation TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (credit_type_id) REFERENCES credit_types (id)
);

-- Auditoría de aprobaciones
CREATE TABLE IF NOT EXISTS approval_audit (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    request_id BIGINT NOT NULL,
    approver_username VARCHAR(100) NOT NULL,
    approval_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    decision VARCHAR(50) NOT NULL,
    comments TEXT,
    conditions TEXT,
    FOREIGN KEY (request_id) REFERENCES credit_requests (id)
);

-- Tabla de amortización (Cuotas)
CREATE TABLE IF NOT EXISTS amortization_schedule (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    request_id BIGINT NOT NULL,
    installment_number INT NOT NULL,
    due_date DATE NOT NULL,
    principal_amount DECIMAL(19, 2) NOT NULL,
    interest_amount DECIMAL(19, 2) NOT NULL,
    insurance_amount DECIMAL(19, 2) DEFAULT 0,
    total_installment DECIMAL(19, 2) NOT NULL,
    remaining_balance DECIMAL(19, 2) NOT NULL,
    status VARCHAR(50) NOT NULL, -- PENDING, PAID, OVERDUE
    FOREIGN KEY (request_id) REFERENCES credit_requests (id)
);

-- Pagos registrados
CREATE TABLE IF NOT EXISTS payments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    installment_id BIGINT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount_paid DECIMAL(19, 2) NOT NULL,
    payment_type VARCHAR(50) NOT NULL, -- NORMAL, ADVANCED, PARTIAL
    receipt_number VARCHAR(100),
    FOREIGN KEY (installment_id) REFERENCES amortization_schedule (id)
);

-- Insertar tipos de crédito base
INSERT INTO
    credit_types (
        name,
        min_amount,
        max_amount,
        min_term_months,
        max_term_months,
        annual_interest_rate,
        policy_description
    )
VALUES (
        'Consumo',
        1000,
        20000,
        6,
        48,
        15.5,
        'Crédito para gastos personales.'
    ),
    (
        'Libre Inversión',
        5000,
        50000,
        12,
        60,
        18.0,
        'Crédito con destino libre.'
    ),
    (
        'Empresarial',
        20000,
        500000,
        12,
        120,
        12.5,
        'Crédito para expansión de negocios.'
    );