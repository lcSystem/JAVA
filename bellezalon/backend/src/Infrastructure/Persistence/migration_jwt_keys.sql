CREATE TABLE IF NOT EXISTS jwt_keys (
    kid VARCHAR(64) PRIMARY KEY,
    secret VARCHAR(255) NOT NULL,
    status ENUM('active', 'expired') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
