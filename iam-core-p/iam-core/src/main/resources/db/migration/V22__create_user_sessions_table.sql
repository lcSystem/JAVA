CREATE TABLE user_sessions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    username VARCHAR(255) NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME,
    expires_at DATETIME NOT NULL,
    token_hash VARCHAR(64) NOT NULL,
    ip_address VARCHAR(255),
    device_info VARCHAR(255),
    status VARCHAR(20) NOT NULL,
    closed_by VARCHAR(255),
    closed_reason VARCHAR(255),
    UNIQUE INDEX idx_token_hash (token_hash),
    INDEX idx_user_id (user_id),
    INDEX idx_status (status),
    INDEX idx_start_time (start_time),
    INDEX idx_expires_at (expires_at)
);