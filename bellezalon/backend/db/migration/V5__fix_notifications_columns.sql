-- V5: Add context_id and context_type to notifications, update type ENUM
ALTER TABLE notifications
ADD COLUMN context_id INT DEFAULT NULL,
ADD COLUMN context_type VARCHAR(50) DEFAULT NULL;

ALTER TABLE notifications
MODIFY COLUMN type ENUM(
    'info',
    'warning',
    'success',
    'error',
    'chat'
) DEFAULT 'info';