CREATE TABLE IF NOT EXISTS parameter_category (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS parameter (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    category_id BIGINT,
    service_name VARCHAR(100) NOT NULL,
    param_key VARCHAR(100) NOT NULL,
    param_value TEXT NOT NULL,
    param_type VARCHAR(50) NOT NULL,
    version INT NOT NULL DEFAULT 0,
    enabled BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by VARCHAR(100),
    updated_by VARCHAR(100),
    UNIQUE KEY uk_parameter_service_key (service_name, param_key),
    CONSTRAINT fk_parameter_category FOREIGN KEY (category_id) REFERENCES parameter_category (id) ON DELETE SET NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- Initial data for testing (creditos-web)
INSERT INTO
    parameter_category (name, description, created_by)
VALUES (
        'CREDITO',
        'Parámetros de configuración de créditos',
        'system'
    );

INSERT INTO
    parameter (
        category_id,
        service_name,
        param_key,
        param_value,
        param_type,
        created_by
    )
VALUES (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'max_credit_amount',
        '50000',
        'DECIMAL',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'min_credit_score',
        '600',
        'INTEGER',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'annual_interest_rate',
        '15.5',
        'DECIMAL',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'late_payment_penalty',
        '5.0',
        'DECIMAL',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'grace_period_days',
        '5',
        'INTEGER',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'automatic_approval_threshold',
        '800',
        'INTEGER',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'risk_scoring_weights',
        '{"credit_history": 0.4, "income": 0.3, "employment": 0.2, "debt": 0.1}',
        'JSON',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'insurance_rate',
        '0.5',
        'DECIMAL',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'max_debt_to_income_ratio',
        '0.4',
        'DECIMAL',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
        ),
        'creditos-web',
        'status_transition_rules',
        '{"SOLICITADO": ["APROBADO", "RECHAZADO"], "APROBADO": ["DESEMBOLSADO", "CANCELADO"]}',
        'JSON',
        'system'
    );