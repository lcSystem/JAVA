-- Create dynamic design configuration table for the mobile credit app
CREATE TABLE IF NOT EXISTS configuracion_creditos (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    config_key VARCHAR(100) NOT NULL UNIQUE,
    config_value TEXT NOT NULL,
    config_type ENUM(
        'STRING',
        'COLOR',
        'IMAGE_URL',
        'JSON'
    ) NOT NULL DEFAULT 'STRING',
    description VARCHAR(255),
    organizacion_id BIGINT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Seed initial design configuration
INSERT INTO
    configuracion_creditos (
        config_key,
        config_value,
        config_type,
        description
    )
VALUES (
        'app_logo_url',
        '/uploads/logo-creditos.png',
        'IMAGE_URL',
        'Logo de la organización'
    ),
    (
        'primary_color',
        '#1A73E8',
        'COLOR',
        'Color primario de la app'
    ),
    (
        'secondary_color',
        '#FF6D00',
        'COLOR',
        'Color secundario/acento'
    ),
    (
        'background_color',
        '#F5F7FA',
        'COLOR',
        'Color de fondo general'
    ),
    (
        'card_color',
        '#FFFFFF',
        'COLOR',
        'Color de las tarjetas'
    ),
    (
        'text_primary_color',
        '#1E293B',
        'COLOR',
        'Color del texto principal'
    ),
    (
        'text_secondary_color',
        '#64748B',
        'COLOR',
        'Color del texto secundario'
    ),
    (
        'gradient_start',
        '#1A73E8',
        'COLOR',
        'Inicio del gradiente principal'
    ),
    (
        'gradient_end',
        '#6366F1',
        'COLOR',
        'Fin del gradiente principal'
    ),
    (
        'login_bg_image_url',
        '/uploads/login-bg-creditos.jpg',
        'IMAGE_URL',
        'Imagen de fondo del login'
    ),
    (
        'org_name',
        'Mi Cooperativa',
        'STRING',
        'Nombre de la organización'
    ),
    (
        'welcome_message',
        'Bienvenido a tu portal de créditos',
        'STRING',
        'Mensaje de bienvenida'
    ),
    (
        'app_version_min',
        '1.0.0',
        'STRING',
        'Versión mínima requerida'
    ),
    (
        'terms_url',
        'https://micooperativa.com/terminos',
        'STRING',
        'URL de términos y condiciones'
    ),
    (
        'support_phone',
        '+57 300 123 4567',
        'STRING',
        'Teléfono de soporte'
    ),
    (
        'support_email',
        'soporte@micooperativa.com',
        'STRING',
        'Email de soporte'
    );