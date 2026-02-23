-- Migration to add debtor_references table
CREATE TABLE IF NOT EXISTS debtor_references (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    credit_request_id BIGINT,
    full_name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    relationship VARCHAR(50) NOT NULL,
    type VARCHAR(20) NOT NULL, -- PERSONAL, FAMILY
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (credit_request_id) REFERENCES credit_requests (id)
);