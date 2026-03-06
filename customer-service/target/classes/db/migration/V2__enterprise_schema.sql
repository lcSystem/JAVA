-- V2__full_enterprise_schema.sql
-- Drop old tables if they exist to restart with BI
DROP TABLE IF EXISTS customer_history;

DROP TABLE IF EXISTS customer_notes;

DROP TABLE IF EXISTS customer_contacts;

DROP TABLE IF EXISTS customer_addresses;

DROP TABLE IF EXISTS customers;

-- STEP 1: Main Table
CREATE TABLE customers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('INDIVIDUAL', 'BUSINESS') NOT NULL,
    name VARCHAR(200) NOT NULL,
    document_number VARCHAR(50) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(50),
    status ENUM(
        'ACTIVE',
        'INACTIVE',
        'BLOCKED',
        'DELETED'
    ) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    updated_by VARCHAR(100),
    deleted_at TIMESTAMP NULL,
    INDEX idx_customer_document (document_number),
    INDEX idx_customer_email (email),
    INDEX idx_customer_status (status),
    INDEX idx_customer_created_at (created_at),
    INDEX idx_customer_type (type)
) ENGINE = InnoDB;

-- STEP 2: Addresses
CREATE TABLE customer_addresses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    street VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    type ENUM(
        'HOME',
        'WORK',
        'BILLING',
        'SHIPPING'
    ),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer_addresses_customer FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE,
    INDEX idx_customer_addresses_customer (customer_id)
) ENGINE = InnoDB;

-- STEP 3: Contacts
CREATE TABLE customer_contacts (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    name VARCHAR(150),
    position VARCHAR(150),
    email VARCHAR(150),
    phone VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer_contacts_customer FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE,
    INDEX idx_customer_contacts_customer (customer_id)
) ENGINE = InnoDB;

-- STEP 4: Notes
CREATE TABLE customer_notes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    note TEXT NOT NULL,
    created_by VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_customer_notes_customer FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE,
    INDEX idx_customer_notes_customer (customer_id)
) ENGINE = InnoDB;

-- STEP 5: History
CREATE TABLE customer_history (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT NOT NULL,
    event_type VARCHAR(100),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    CONSTRAINT fk_customer_history_customer FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE,
    INDEX idx_customer_history_customer (customer_id)
) ENGINE = InnoDB;