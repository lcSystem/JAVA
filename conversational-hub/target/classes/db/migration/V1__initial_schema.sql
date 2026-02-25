CREATE TABLE channels (
    id VARCHAR(36) PRIMARY KEY,
    tenant_id VARCHAR(50) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    erp_entity_id VARCHAR(50),
    erp_entity_type VARCHAR(50),
    created_at TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    is_automatic BOOLEAN DEFAULT FALSE
);

CREATE TABLE messages (
    id VARCHAR(36) PRIMARY KEY,
    channel_id VARCHAR(36) NOT NULL,
    sender_id VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    type VARCHAR(20) NOT NULL,
    metadata TEXT,
    timestamp TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    CONSTRAINT fk_channel FOREIGN KEY (channel_id) REFERENCES channels (id)
);

CREATE INDEX idx_channels_tenant ON channels (tenant_id);

CREATE INDEX idx_messages_channel ON messages (channel_id);

CREATE INDEX idx_channels_erp_entity ON channels (
    erp_entity_id,
    erp_entity_type
);