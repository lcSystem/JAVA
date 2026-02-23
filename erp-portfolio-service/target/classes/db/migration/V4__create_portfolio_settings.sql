-- Portfolio Settings key-value store with seed data
CREATE TABLE IF NOT EXISTS portfolio_settings (
    id BINARY(16) NOT NULL PRIMARY KEY,
    setting_key VARCHAR(100) NOT NULL UNIQUE,
    setting_value TEXT NOT NULL,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Seed default settings
INSERT INTO
    portfolio_settings (
        id,
        setting_key,
        setting_value,
        description
    )
VALUES (
        UNHEX(
            REPLACE (UUID(), '-', '')
        ),
        'max_file_size_mb',
        '10',
        'Maximum upload file size in megabytes'
    ),
    (
        UNHEX(
            REPLACE (UUID(), '-', '')
        ),
        'allowed_extensions',
        'jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,ppt,pptx',
        'Comma-separated list of allowed file extensions'
    ),
    (
        UNHEX(
            REPLACE (UUID(), '-', '')
        ),
        'require_reauth',
        'false',
        'Whether to require re-authentication before portfolio access'
    ),
    (
        UNHEX(
            REPLACE (UUID(), '-', '')
        ),
        'storage_provider',
        'filesystem',
        'Storage provider type: filesystem, minio, s3'
    );