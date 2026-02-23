-- Portfolio File table with UUID as BINARY(16)
CREATE TABLE IF NOT EXISTS portfolio_file (
    id BINARY(16) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    original_name VARCHAR(255) NOT NULL,
    folder_id BINARY(16),
    owner_id VARCHAR(100) NOT NULL,
    storage_path TEXT NOT NULL,
    mime_type VARCHAR(100),
    extension VARCHAR(20),
    size_bytes BIGINT NOT NULL,
    checksum VARCHAR(64),
    tags TEXT,
    file_type VARCHAR(50),
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_file_folder FOREIGN KEY (folder_id) REFERENCES portfolio_folder (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Performance indices
CREATE INDEX idx_file_folder ON portfolio_file (folder_id);

CREATE INDEX idx_file_owner ON portfolio_file (owner_id);

CREATE INDEX idx_file_deleted ON portfolio_file (deleted);

CREATE INDEX idx_file_folder_deleted ON portfolio_file (folder_id, deleted);

CREATE INDEX idx_file_owner_deleted ON portfolio_file (owner_id, deleted);