-- Migration: Notifications system
CREATE TABLE IF NOT EXISTS `notifications` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `user_id` INT(11) DEFAULT NULL,
    `title` VARCHAR(100) NOT NULL,
    `message` VARCHAR(500) NOT NULL,
    `type` ENUM(
        'info',
        'warning',
        'success',
        'error'
    ) DEFAULT 'info',
    `is_read` TINYINT(1) DEFAULT 0,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `idx_user_notif` (`user_id`, `is_read`),
    FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Extend users table for client registration info
ALTER TABLE `users`
ADD COLUMN `full_name` VARCHAR(100) DEFAULT NULL AFTER `username`;

ALTER TABLE `users`
ADD COLUMN `email` VARCHAR(150) DEFAULT NULL AFTER `full_name`;

ALTER TABLE `users`
ADD COLUMN `phone` VARCHAR(20) DEFAULT NULL AFTER `email`;