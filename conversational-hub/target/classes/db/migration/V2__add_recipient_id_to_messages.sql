ALTER TABLE messages ADD COLUMN recipient_id VARCHAR(255);

CREATE INDEX idx_messages_recipient_timestamp ON messages (recipient_id, timestamp);

CREATE INDEX idx_messages_sender_timestamp ON messages (sender_id, timestamp);