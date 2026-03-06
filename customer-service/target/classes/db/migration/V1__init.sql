CREATE TABLE customers (
    id BINARY(16) PRIMARY KEY,
    customer_type VARCHAR(20) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    business_name VARCHAR(200),
    document_type VARCHAR(20) NOT NULL,
    document_number VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    status VARCHAR(20) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    UNIQUE KEY uk_customer_document (document_number),
    UNIQUE KEY uk_customer_email (email),
    INDEX idx_customer_document (document_number),
    INDEX idx_customer_email (email)
) ENGINE = InnoDB;

CREATE TABLE customer_addresses (
    id BINARY(16) PRIMARY KEY,
    customer_id BINARY(16) NOT NULL,
    country VARCHAR(100),
    state VARCHAR(100),
    city VARCHAR(100),
    address VARCHAR(255),
    postal_code VARCHAR(20),
    address_type VARCHAR(20),
    CONSTRAINT fk_address_customer FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE customer_contacts (
    id BINARY(16) PRIMARY KEY,
    customer_id BINARY(16) NOT NULL,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    CONSTRAINT fk_contact_customer FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE CASCADE
) ENGINE = InnoDB;