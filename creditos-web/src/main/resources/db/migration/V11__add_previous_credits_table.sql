CREATE TABLE previous_credits (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    credit_request_id BIGINT,
    bank_name VARCHAR(255) NOT NULL,
    amount DECIMAL(19, 2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    monthly_installment DECIMAL(19, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (credit_request_id) REFERENCES credit_requests (id) ON DELETE CASCADE
);