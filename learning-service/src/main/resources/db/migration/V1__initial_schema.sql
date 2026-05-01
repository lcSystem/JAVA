-- Database Schema for Gamified K-12 Learning Platform
-- Target: MySQL 8.0+

-- 1. Academic Structure
CREATE TABLE subjects (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT
);

CREATE TABLE units (
    id VARCHAR(36) PRIMARY KEY,
    subject_id VARCHAR(36) NOT NULL,
    name VARCHAR(255) NOT NULL,
    order_index INT NOT NULL,
    FOREIGN KEY (subject_id) REFERENCES subjects (id)
);

CREATE TABLE lessons (
    id VARCHAR(36) PRIMARY KEY,
    unit_id VARCHAR(36) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    xp_reward INT DEFAULT 10,
    FOREIGN KEY (unit_id) REFERENCES units (id)
);

CREATE TABLE challenges (
    id VARCHAR(36) PRIMARY KEY,
    lesson_id VARCHAR(36) NOT NULL,
    type ENUM(
        'MULTIPLE_CHOICE',
        'TRUE_FALSE',
        'FILL_BLANK',
        'NUMERIC_INPUT',
        'DRAG_AND_DROP',
        'TEXT_INPUT'
    ) NOT NULL,
    content JSON NOT NULL,
    validation_rules JSON,
    FOREIGN KEY (lesson_id) REFERENCES lessons (id)
);

-- 2. Student Progress & Gamification
CREATE TABLE students (
    id VARCHAR(36) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE student_progress (
    id VARCHAR(36) PRIMARY KEY,
    student_id VARCHAR(36) NOT NULL,
    subject_id VARCHAR(36) NOT NULL,
    current_level INT DEFAULT 1,
    total_xp BIGINT DEFAULT 0,
    hearts INT DEFAULT 5,
    streak_days INT DEFAULT 0,
    last_participation_at TIMESTAMP,
    UNIQUE (student_id, subject_id),
    FOREIGN KEY (student_id) REFERENCES students (id),
    FOREIGN KEY (subject_id) REFERENCES subjects (id)
);

CREATE TABLE lesson_sessions (
    id VARCHAR(36) PRIMARY KEY,
    student_id VARCHAR(36) NOT NULL,
    lesson_id VARCHAR(36) NOT NULL,
    status ENUM(
        'IN_PROGRESS',
        'COMPLETED',
        'FAILED'
    ) DEFAULT 'IN_PROGRESS',
    current_challenge_index INT DEFAULT 0,
    correct_answers INT DEFAULT 0,
    wrong_answers INT DEFAULT 0,
    hearts_remaining INT DEFAULT 5,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    finished_at TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students (id),
    FOREIGN KEY (lesson_id) REFERENCES lessons (id)
);