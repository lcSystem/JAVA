-- Portfolio Folder table with UUID as BINARY(16)
CREATE TABLE IF NOT EXISTS portfolio_folder (
    id BINARY(16) NOT NULL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    parent_id BINARY(16),
    owner_id VARCHAR(100) NOT NULL,
    path TEXT NOT NULL,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_folder_parent FOREIGN KEY (parent_id) REFERENCES portfolio_folder (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Performance indices
CREATE INDEX idx_folder_parent ON portfolio_folder (parent_id);

CREATE INDEX idx_folder_owner ON portfolio_folder (owner_id);

CREATE INDEX idx_folder_parent_deleted ON portfolio_folder (parent_id, deleted);

CREATE INDEX idx_folder_owner_deleted ON portfolio_folder (owner_id, deleted);