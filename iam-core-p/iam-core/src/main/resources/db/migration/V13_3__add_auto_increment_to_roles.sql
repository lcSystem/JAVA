-- V13_3: Add AUTO_INCREMENT to roles.role_id
-- Required for GenerationType.IDENTITY in Role entity
ALTER TABLE roles MODIFY COLUMN role_id INT AUTO_INCREMENT;