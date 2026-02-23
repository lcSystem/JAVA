-- Add parameters for erp-portfolio-service
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
            LIMIT 1
        ),
        'erp-portfolio-service',
        'max_file_size_mb',
        '10',
        'INTEGER',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
            LIMIT 1
        ),
        'erp-portfolio-service',
        'allowed_extensions',
        'jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,ppt,pptx,txt',
        'STRING',
        'system'
    ),
    (
        (
            SELECT id
            FROM parameter_category
            WHERE
                name = 'CREDITO'
            LIMIT 1
        ),
        'erp-portfolio-service',
        'require_reauth',
        'false',
        'BOOLEAN',
        'system'
    );