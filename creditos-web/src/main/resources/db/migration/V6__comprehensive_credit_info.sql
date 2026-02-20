-- Comprehensive Credit Information System Migration
CREATE TABLE IF NOT EXISTS co_debtor_profiles (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(255) NOT NULL,
    document_id VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(20),
    address VARCHAR(255),
    email VARCHAR(100),

-- Laboral Information
company_name VARCHAR(255),
position VARCHAR(100),
employment_years INT,
work_phone VARCHAR(20),

-- Financial Information
monthly_income DECIMAL(19, 2),
    other_income DECIMAL(19, 2),
    monthly_expenses DECIMAL(19, 2),
    
    is_legal_representative BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_codebtor_document (document_id)
);

CREATE TABLE IF NOT EXISTS credit_references (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    owner_id BIGINT NOT NULL, -- Can be linked to applicant or co-debtor
    owner_type VARCHAR(20) NOT NULL, -- 'APPLICANT' or 'CO_DEBTOR'
    reference_type VARCHAR(20) NOT NULL, -- 'FAMILY' or 'PERSONAL'
    full_name VARCHAR(255) NOT NULL,
    relationship VARCHAR(50),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE credit_requests
ADD COLUMN co_debtor_profile_id BIGINT,
ADD COLUMN representative_profile_id BIGINT,
ADD FOREIGN KEY (co_debtor_profile_id) REFERENCES co_debtor_profiles (id),
ADD FOREIGN KEY (representative_profile_id) REFERENCES co_debtor_profiles (id);