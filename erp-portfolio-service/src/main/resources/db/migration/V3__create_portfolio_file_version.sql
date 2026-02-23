-- File Version tracking table
CREATE TABLE IF NOT EXISTS portfolio_file_version (
    id BINARY(16) NOT NULL PRIMARY KEY,
    file_id BINARY(16) NOT NULL,
    version_number INT NOT NULL,
    storage_path TEXT NOT NULL,
    size_bytes BIGINT NOT NULL,
    checksum VARCHAR(64),
    created_by VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_version_file FOREIGN KEY (file_id) REFERENCES portfolio_file (id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Performance indices
CREATE INDEX idx_version_file ON portfolio_file_version (file_id);

CREATE INDEX idx_version_file_number ON portfolio_file_version (file_id, version_number);