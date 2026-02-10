-- V11__create_leave_type_table.sql

CREATE TABLE leave_type (
    leave_type_id BIGINT NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    leave_name VARCHAR(100) NOT NULL,
    days INT NOT NULL,
    leave_status VARCHAR(30) NOT NULL,
    PRIMARY KEY (leave_type_id),
    UNIQUE KEY uk_leave_type_name (leave_name)
);
