CREATE TABLE report_requests (
    id VARCHAR(36) PRIMARY KEY,
    report_type VARCHAR(50) NOT NULL,
    parameters JSON,
    requested_by VARCHAR(255),
    status VARCHAR(20) NOT NULL,
    file_url VARCHAR(500),
    error_message TEXT,
    last_error TEXT,
    retry_count INT DEFAULT 0,
    version BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    INDEX idx_status (status),
    INDEX idx_requested_by (requested_by)
);

CREATE TABLE processed_events (
    id VARCHAR(36) PRIMARY KEY,
    event_id VARCHAR(255) UNIQUE NOT NULL,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);