-- ============================================================
-- V5: Enterprise Catalog System
-- ============================================================

CREATE TABLE IF NOT EXISTS catalog (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(500),
    type ENUM('STATIC', 'DYNAMIC', 'SYSTEM') NOT NULL DEFAULT 'DYNAMIC',
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS catalog_item (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    catalog_code VARCHAR(50) NOT NULL,
    parent_id BIGINT NULL,
    company_id BIGINT NULL,
    item_code VARCHAR(50) NOT NULL,
    name VARCHAR(200) NOT NULL,
    description VARCHAR(500),
    order_index INT NOT NULL DEFAULT 0,
    path VARCHAR(500),
    level INT NOT NULL DEFAULT 0,
    extra_data JSON,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),

-- Multi-tenant uniqueness: same code allowed in different companies
CONSTRAINT uk_catalog_item_tenant_code UNIQUE (
    catalog_code,
    item_code,
    company_id
),

-- FK to catalog
CONSTRAINT fk_catalog_item_catalog FOREIGN KEY (catalog_code) REFERENCES catalog (code) ON UPDATE CASCADE,

-- Self-referencing hierarchy
CONSTRAINT fk_catalog_item_parent FOREIGN KEY (parent_id) REFERENCES catalog_item (id) ON DELETE SET NULL,

-- Performance indexes
INDEX idx_catalog_item_catalog (catalog_code),
    INDEX idx_catalog_item_company (company_id),
    INDEX idx_catalog_item_parent (parent_id),
    INDEX idx_catalog_item_path (path),
    INDEX idx_catalog_item_enabled (catalog_code, enabled, deleted)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;