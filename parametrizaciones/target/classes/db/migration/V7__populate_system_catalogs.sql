-- ============================================================
-- V7: Seed System Category Catalogs
-- ============================================================

-- ==================== 10. SYSTEM ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'NOTIFICATION_TYPE',
        'Tipos de Notificación',
        'Tipos de notificación del sistema',
        'SYSTEM',
        'system'
    ),
    (
        'AUDIT_ACTION',
        'Acciones de Auditoría',
        'Tipos de acción registrada en auditoría',
        'SYSTEM',
        'system'
    ),
    (
        'LOG_LEVEL',
        'Niveles de Log',
        'Niveles de severidad de logs',
        'SYSTEM',
        'system'
    );

-- Notification Types
INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        extra_data,
        created_by
    )
VALUES (
        'NOTIFICATION_TYPE',
        'INFO',
        'Información',
        1,
        '{"icon": "info", "color": "#3B82F6"}',
        'system'
    ),
    (
        'NOTIFICATION_TYPE',
        'WARNING',
        'Advertencia',
        2,
        '{"icon": "alert-triangle", "color": "#F59E0B"}',
        'system'
    ),
    (
        'NOTIFICATION_TYPE',
        'ERROR',
        'Error',
        3,
        '{"icon": "x-circle", "color": "#EF4444"}',
        'system'
    ),
    (
        'NOTIFICATION_TYPE',
        'SUCCESS',
        'Éxito',
        4,
        '{"icon": "check-circle", "color": "#10B981"}',
        'system'
    ),
    (
        'NOTIFICATION_TYPE',
        'SYSTEM',
        'Sistema',
        5,
        '{"icon": "server", "color": "#6B7280"}',
        'system'
    );

-- Audit Actions
INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        extra_data,
        created_by
    )
VALUES (
        'AUDIT_ACTION',
        'CREATE',
        'Crear',
        1,
        '{"severity": "LOW"}',
        'system'
    ),
    (
        'AUDIT_ACTION',
        'READ',
        'Leer',
        2,
        '{"severity": "LOW"}',
        'system'
    ),
    (
        'AUDIT_ACTION',
        'UPDATE',
        'Actualizar',
        3,
        '{"severity": "MEDIUM"}',
        'system'
    ),
    (
        'AUDIT_ACTION',
        'DELETE',
        'Eliminar',
        4,
        '{"severity": "HIGH"}',
        'system'
    ),
    (
        'AUDIT_ACTION',
        'LOGIN',
        'Inicio de Sesión',
        5,
        '{"severity": "LOW"}',
        'system'
    ),
    (
        'AUDIT_ACTION',
        'LOGOUT',
        'Cierre de Sesión',
        6,
        '{"severity": "LOW"}',
        'system'
    ),
    (
        'AUDIT_ACTION',
        'EXPORT',
        'Exportar',
        7,
        '{"severity": "MEDIUM"}',
        'system'
    );

-- Log Levels
INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        extra_data,
        created_by
    )
VALUES (
        'LOG_LEVEL',
        'TRACE',
        'Trace',
        1,
        '{"numeric": 0, "color": "#9CA3AF"}',
        'system'
    ),
    (
        'LOG_LEVEL',
        'DEBUG',
        'Debug',
        2,
        '{"numeric": 1, "color": "#6B7280"}',
        'system'
    ),
    (
        'LOG_LEVEL',
        'INFO',
        'Info',
        3,
        '{"numeric": 2, "color": "#3B82F6"}',
        'system'
    ),
    (
        'LOG_LEVEL',
        'WARN',
        'Warning',
        4,
        '{"numeric": 3, "color": "#F59E0B"}',
        'system'
    ),
    (
        'LOG_LEVEL',
        'ERROR',
        'Error',
        5,
        '{"numeric": 4, "color": "#EF4444"}',
        'system'
    ),
    (
        'LOG_LEVEL',
        'FATAL',
        'Fatal',
        6,
        '{"numeric": 5, "color": "#7C3AED"}',
        'system'
    );