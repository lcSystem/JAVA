-- Create refresh tokens table for client JWT token management
CREATE TABLE IF NOT EXISTS client_refresh_tokens (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    customer_id BIGINT NOT NULL,
    token VARCHAR(500) NOT NULL UNIQUE,
    device_info VARCHAR(255),
    expires_at DATETIME NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    revoked BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (customer_id) REFERENCES customers (id)
);

CREATE INDEX IF NOT EXISTS idx_refresh_token ON client_refresh_tokens (token);

CREATE INDEX IF NOT EXISTS idx_refresh_customer ON client_refresh_tokens (customer_id);