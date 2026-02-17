CREATE TABLE IF NOT EXISTS app_design_settings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    app_name VARCHAR(255) DEFAULT 'IAM ERP',
    app_font VARCHAR(255) DEFAULT 'Inter',
    logo_url VARCHAR(255),
    primary_color VARCHAR(50) DEFAULT '#4F46E5',
    secondary_color VARCHAR(50) DEFAULT '#10B981',
    accent_color VARCHAR(50) DEFAULT '#F59E0B',
    is_dark_mode BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;