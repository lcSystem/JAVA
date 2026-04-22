-- Migration: Add context to notifications for deep linking
ALTER TABLE `notifications`
ADD COLUMN `context_id` INT(11) DEFAULT NULL,
ADD COLUMN `context_type` VARCHAR(50) DEFAULT NULL;