-- Add parameter to control if extra info is requested for debtor/co-debtor
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
        'ask_debtor_extra_info',
        'true',
        'BOOLEAN',
        'system'
    );