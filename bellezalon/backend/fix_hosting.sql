-- FIX PARA TABLAS FALTANTES EN HOSTING
-- Ejecuta este SQL en tu phpMyAdmin

CREATE TABLE IF NOT EXISTS `app_settings` (
    `key_name` VARCHAR(100) PRIMARY KEY,
    `setting_value` TEXT NOT NULL,
    `category` ENUM(
        'DESIGN',
        'OPERATIONAL',
        'POLICIES',
        'GENERAL'
    ) NOT NULL,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

-- Insertar configuración inicial necesaria para que la app no falle al cargar
INSERT IGNORE INTO
    `app_settings` (
        `key_name`,
        `setting_value`,
        `category`
    )
VALUES (
        'primary_color',
        '#8C4D53',
        'DESIGN'
    ),
    (
        'secondary_color',
        '#785A29',
        'DESIGN'
    ),
    (
        'font_family',
        'NotoSerif',
        'DESIGN'
    ),
    (
        'theme_mode',
        'light',
        'DESIGN'
    ),
    (
        'salon_logo_url',
        '',
        'DESIGN'
    ),
    (
        'max_appointments_per_day',
        '20',
        'OPERATIONAL'
    ),
    (
        'cancellation_policy_hours',
        '24',
        'POLICIES'
    ),
    (
        'advance_payment_required',
        'false',
        'POLICIES'
    ),
    (
        'push_notifications_enabled',
        'true',
        'OPERATIONAL'
    );