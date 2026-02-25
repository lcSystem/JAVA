CREATE TABLE dynamic_report_history (
    id VARCHAR(36) PRIMARY KEY,
    template_id VARCHAR(36) NOT NULL,
    template_name VARCHAR(255),
    microservice_id VARCHAR(100),
    entity_id VARCHAR(100),
    format VARCHAR(20),
    created_by VARCHAR(255),
    created_at TIMESTAMP
);