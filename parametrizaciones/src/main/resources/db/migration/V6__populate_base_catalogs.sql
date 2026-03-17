-- ============================================================
-- V6: Seed Base Catalogs (Enterprise ERP Data)
-- ============================================================

-- ==================== 1. LOCATION ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'COUNTRY',
        'Países',
        'Catálogo de países',
        'STATIC',
        'system'
    ),
    (
        'DEPARTMENT',
        'Departamentos',
        'Departamentos / Estados / Provincias',
        'STATIC',
        'system'
    ),
    (
        'CITY',
        'Ciudades',
        'Ciudades / Municipios',
        'STATIC',
        'system'
    ),
    (
        'NEIGHBORHOOD',
        'Barrios / Zonas',
        'Barrios, zonas o localidades',
        'DYNAMIC',
        'system'
    ),
    (
        'POSTAL_CODE',
        'Códigos Postales',
        'Códigos postales por zona',
        'DYNAMIC',
        'system'
    );

-- Countries
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
        'COUNTRY',
        'CO',
        'Colombia',
        1,
        '{"phoneCode": "+57", "currency": "COP", "iso3": "COL"}',
        'system'
    ),
    (
        'COUNTRY',
        'US',
        'Estados Unidos',
        2,
        '{"phoneCode": "+1", "currency": "USD", "iso3": "USA"}',
        'system'
    ),
    (
        'COUNTRY',
        'MX',
        'México',
        3,
        '{"phoneCode": "+52", "currency": "MXN", "iso3": "MEX"}',
        'system'
    ),
    (
        'COUNTRY',
        'EC',
        'Ecuador',
        4,
        '{"phoneCode": "+593", "currency": "USD", "iso3": "ECU"}',
        'system'
    ),
    (
        'COUNTRY',
        'PE',
        'Perú',
        5,
        '{"phoneCode": "+51", "currency": "PEN", "iso3": "PER"}',
        'system'
    ),
    (
        'COUNTRY',
        'PA',
        'Panamá',
        6,
        '{"phoneCode": "+507", "currency": "PAB", "iso3": "PAN"}',
        'system'
    );

-- Departments (Colombia - linked to CO)
INSERT INTO
    catalog_item (
        catalog_code,
        parent_id,
        item_code,
        name,
        order_index,
        extra_data,
        created_by
    )
VALUES (
        'DEPARTMENT',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'COUNTRY'
                AND item_code = 'CO'
        ),
        'ANT',
        'Antioquia',
        1,
        '{"daneCode": "05"}',
        'system'
    ),
    (
        'DEPARTMENT',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'COUNTRY'
                AND item_code = 'CO'
        ),
        'BOG',
        'Bogotá D.C.',
        2,
        '{"daneCode": "11"}',
        'system'
    ),
    (
        'DEPARTMENT',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'COUNTRY'
                AND item_code = 'CO'
        ),
        'VAL',
        'Valle del Cauca',
        3,
        '{"daneCode": "76"}',
        'system'
    ),
    (
        'DEPARTMENT',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'COUNTRY'
                AND item_code = 'CO'
        ),
        'ATL',
        'Atlántico',
        4,
        '{"daneCode": "08"}',
        'system'
    ),
    (
        'DEPARTMENT',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'COUNTRY'
                AND item_code = 'CO'
        ),
        'SAN',
        'Santander',
        5,
        '{"daneCode": "68"}',
        'system'
    );

-- Cities (Colombia samples)
INSERT INTO
    catalog_item (
        catalog_code,
        parent_id,
        item_code,
        name,
        order_index,
        extra_data,
        created_by
    )
VALUES (
        'CITY',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'DEPARTMENT'
                AND item_code = 'ANT'
        ),
        'MDE',
        'Medellín',
        1,
        '{"daneCode": "05001", "latitude": 6.2442, "longitude": -75.5812}',
        'system'
    ),
    (
        'CITY',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'DEPARTMENT'
                AND item_code = 'ANT'
        ),
        'ENV',
        'Envigado',
        2,
        '{"daneCode": "05266", "latitude": 6.1711, "longitude": -75.5907}',
        'system'
    ),
    (
        'CITY',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'DEPARTMENT'
                AND item_code = 'BOG'
        ),
        'BOG',
        'Bogotá',
        1,
        '{"daneCode": "11001", "latitude": 4.7110, "longitude": -74.0721}',
        'system'
    ),
    (
        'CITY',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'DEPARTMENT'
                AND item_code = 'VAL'
        ),
        'CAL',
        'Cali',
        1,
        '{"daneCode": "76001", "latitude": 3.4516, "longitude": -76.5320}',
        'system'
    ),
    (
        'CITY',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'DEPARTMENT'
                AND item_code = 'ATL'
        ),
        'BAQ',
        'Barranquilla',
        1,
        '{"daneCode": "08001", "latitude": 10.9685, "longitude": -74.7813}',
        'system'
    ),
    (
        'CITY',
        (
            SELECT id
            FROM catalog_item
            WHERE
                catalog_code = 'DEPARTMENT'
                AND item_code = 'SAN'
        ),
        'BGA',
        'Bucaramanga',
        1,
        '{"daneCode": "68001", "latitude": 7.1193, "longitude": -73.1227}',
        'system'
    );

-- ==================== 2. ORGANIZATION ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'COMPANY',
        'Empresas',
        'Empresas del grupo',
        'DYNAMIC',
        'system'
    ),
    (
        'BRANCH',
        'Sucursales',
        'Sucursales o sedes',
        'DYNAMIC',
        'system'
    ),
    (
        'COST_CENTER',
        'Centros de Costo',
        'Centros de costo contables',
        'DYNAMIC',
        'system'
    ),
    (
        'AREA',
        'Áreas / Departamentos',
        'Áreas organizacionales',
        'DYNAMIC',
        'system'
    ),
    (
        'JOB_POSITION',
        'Cargos',
        'Cargos laborales',
        'DYNAMIC',
        'system'
    );

-- ==================== 3. PEOPLE & THIRD PARTIES ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'DOCUMENT_TYPE',
        'Tipos de Documento',
        'Tipos de documento de identidad',
        'STATIC',
        'system'
    ),
    (
        'THIRD_PARTY_TYPE',
        'Tipos de Tercero',
        'Cliente, Proveedor, Empleado',
        'STATIC',
        'system'
    ),
    (
        'PERSON_TYPE',
        'Tipo de Persona',
        'Natural o Jurídica',
        'STATIC',
        'system'
    ),
    (
        'GENDER',
        'Género',
        'Género de la persona',
        'STATIC',
        'system'
    ),
    (
        'MARITAL_STATUS',
        'Estado Civil',
        'Estado civil de la persona',
        'STATIC',
        'system'
    );

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
        'DOCUMENT_TYPE',
        'CC',
        'Cédula de Ciudadanía',
        1,
        '{"country": "CO", "length": 10}',
        'system'
    ),
    (
        'DOCUMENT_TYPE',
        'NIT',
        'NIT',
        2,
        '{"country": "CO", "hasDV": true}',
        'system'
    ),
    (
        'DOCUMENT_TYPE',
        'CE',
        'Cédula de Extranjería',
        3,
        '{"country": "CO"}',
        'system'
    ),
    (
        'DOCUMENT_TYPE',
        'PP',
        'Pasaporte',
        4,
        '{"international": true}',
        'system'
    ),
    (
        'DOCUMENT_TYPE',
        'TI',
        'Tarjeta de Identidad',
        5,
        '{"country": "CO", "minorOnly": true}',
        'system'
    ),
    (
        'DOCUMENT_TYPE',
        'RC',
        'Registro Civil',
        6,
        '{"country": "CO"}',
        'system'
    );

INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        created_by
    )
VALUES (
        'THIRD_PARTY_TYPE',
        'CLIENT',
        'Cliente',
        1,
        'system'
    ),
    (
        'THIRD_PARTY_TYPE',
        'SUPPLIER',
        'Proveedor',
        2,
        'system'
    ),
    (
        'THIRD_PARTY_TYPE',
        'EMPLOYEE',
        'Empleado',
        3,
        'system'
    ),
    (
        'THIRD_PARTY_TYPE',
        'PARTNER',
        'Socio',
        4,
        'system'
    );

INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        created_by
    )
VALUES (
        'PERSON_TYPE',
        'NATURAL',
        'Persona Natural',
        1,
        'system'
    ),
    (
        'PERSON_TYPE',
        'LEGAL',
        'Persona Jurídica',
        2,
        'system'
    );

INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        created_by
    )
VALUES (
        'GENDER',
        'M',
        'Masculino',
        1,
        'system'
    ),
    (
        'GENDER',
        'F',
        'Femenino',
        2,
        'system'
    ),
    (
        'GENDER',
        'O',
        'Otro',
        3,
        'system'
    );

INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        created_by
    )
VALUES (
        'MARITAL_STATUS',
        'SINGLE',
        'Soltero(a)',
        1,
        'system'
    ),
    (
        'MARITAL_STATUS',
        'MARRIED',
        'Casado(a)',
        2,
        'system'
    ),
    (
        'MARITAL_STATUS',
        'DIVORCED',
        'Divorciado(a)',
        3,
        'system'
    ),
    (
        'MARITAL_STATUS',
        'WIDOWED',
        'Viudo(a)',
        4,
        'system'
    ),
    (
        'MARITAL_STATUS',
        'FREE_UNION',
        'Unión Libre',
        5,
        'system'
    );

-- ==================== 4. FINANCE ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'CURRENCY',
        'Monedas',
        'Monedas del sistema',
        'STATIC',
        'system'
    ),
    (
        'TAX_TYPE',
        'Tipos de Impuesto',
        'IVA, Retención, ICA, etc.',
        'STATIC',
        'system'
    ),
    (
        'PAYMENT_METHOD',
        'Formas de Pago',
        'Efectivo, transferencia, crédito',
        'STATIC',
        'system'
    ),
    (
        'PAYMENT_MEDIUM',
        'Medios de Pago',
        'Nequi, banco, tarjeta, etc.',
        'DYNAMIC',
        'system'
    ),
    (
        'PAYMENT_TERM',
        'Plazos de Pago',
        'Plazos de pago comerciales',
        'DYNAMIC',
        'system'
    ),
    (
        'VOUCHER_TYPE',
        'Tipos de Comprobante',
        'Factura, nota crédito, etc.',
        'STATIC',
        'system'
    );

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
        'CURRENCY',
        'COP',
        'Peso Colombiano',
        1,
        '{"symbol": "$", "decimals": 2, "isoNumeric": "170"}',
        'system'
    ),
    (
        'CURRENCY',
        'USD',
        'Dólar Estadounidense',
        2,
        '{"symbol": "US$", "decimals": 2, "isoNumeric": "840"}',
        'system'
    ),
    (
        'CURRENCY',
        'EUR',
        'Euro',
        3,
        '{"symbol": "€", "decimals": 2, "isoNumeric": "978"}',
        'system'
    );

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
        'TAX_TYPE',
        'IVA',
        'IVA',
        1,
        '{"defaultRate": 19.0}',
        'system'
    ),
    (
        'TAX_TYPE',
        'RETEFUENTE',
        'Retención en la Fuente',
        2,
        '{"defaultRate": 3.5}',
        'system'
    ),
    (
        'TAX_TYPE',
        'RETEIVA',
        'Retención de IVA',
        3,
        '{"defaultRate": 15.0}',
        'system'
    ),
    (
        'TAX_TYPE',
        'ICA',
        'Impuesto de Industria y Comercio',
        4,
        '{"defaultRate": 0.69}',
        'system'
    );

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
        'PAYMENT_METHOD',
        'CASH',
        'Efectivo',
        1,
        '{"requiresRef": false}',
        'system'
    ),
    (
        'PAYMENT_METHOD',
        'TRANSFER',
        'Transferencia Bancaria',
        2,
        '{"requiresRef": true}',
        'system'
    ),
    (
        'PAYMENT_METHOD',
        'CREDIT',
        'Crédito',
        3,
        '{"requiresRef": false, "generateReceivable": true}',
        'system'
    ),
    (
        'PAYMENT_METHOD',
        'CHECK',
        'Cheque',
        4,
        '{"requiresRef": true}',
        'system'
    );

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
        'PAYMENT_MEDIUM',
        'NEQUI',
        'Nequi',
        1,
        '{"digital": true, "provider": "Bancolombia"}',
        'system'
    ),
    (
        'PAYMENT_MEDIUM',
        'DAVIPLATA',
        'Daviplata',
        2,
        '{"digital": true, "provider": "Davivienda"}',
        'system'
    ),
    (
        'PAYMENT_MEDIUM',
        'BANK',
        'Cuenta Bancaria',
        3,
        '{"digital": false}',
        'system'
    ),
    (
        'PAYMENT_MEDIUM',
        'CARD',
        'Tarjeta Débito/Crédito',
        4,
        '{"digital": true}',
        'system'
    );

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
        'PAYMENT_TERM',
        '0D',
        'Contado',
        1,
        '{"days": 0}',
        'system'
    ),
    (
        'PAYMENT_TERM',
        '15D',
        '15 días',
        2,
        '{"days": 15}',
        'system'
    ),
    (
        'PAYMENT_TERM',
        '30D',
        '30 días',
        3,
        '{"days": 30}',
        'system'
    ),
    (
        'PAYMENT_TERM',
        '60D',
        '60 días',
        4,
        '{"days": 60}',
        'system'
    ),
    (
        'PAYMENT_TERM',
        '90D',
        '90 días',
        5,
        '{"days": 90}',
        'system'
    );

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
        'VOUCHER_TYPE',
        'INVOICE',
        'Factura de Venta',
        1,
        '{"prefix": "FV"}',
        'system'
    ),
    (
        'VOUCHER_TYPE',
        'CREDIT_NOTE',
        'Nota Crédito',
        2,
        '{"prefix": "NC"}',
        'system'
    ),
    (
        'VOUCHER_TYPE',
        'DEBIT_NOTE',
        'Nota Débito',
        3,
        '{"prefix": "ND"}',
        'system'
    ),
    (
        'VOUCHER_TYPE',
        'RECEIPT',
        'Recibo de Caja',
        4,
        '{"prefix": "RC"}',
        'system'
    );

-- ==================== 5. INVENTORY & PRODUCTS ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'PRODUCT_CATEGORY',
        'Categorías de Producto',
        'Categorías principales de productos',
        'DYNAMIC',
        'system'
    ),
    (
        'UNIT_OF_MEASURE',
        'Unidades de Medida',
        'kg, unidad, litro, etc.',
        'STATIC',
        'system'
    ),
    (
        'PRODUCT_TYPE',
        'Tipo de Producto',
        'Servicio o Físico',
        'STATIC',
        'system'
    ),
    (
        'WAREHOUSE',
        'Bodegas',
        'Almacenes o bodegas',
        'DYNAMIC',
        'system'
    ),
    (
        'MOVEMENT_TYPE',
        'Tipos de Movimiento',
        'Entrada, salida, ajuste',
        'STATIC',
        'system'
    );

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
        'UNIT_OF_MEASURE',
        'UND',
        'Unidad',
        1,
        '{"abbreviation": "und"}',
        'system'
    ),
    (
        'UNIT_OF_MEASURE',
        'KG',
        'Kilogramo',
        2,
        '{"abbreviation": "kg"}',
        'system'
    ),
    (
        'UNIT_OF_MEASURE',
        'LT',
        'Litro',
        3,
        '{"abbreviation": "lt"}',
        'system'
    ),
    (
        'UNIT_OF_MEASURE',
        'MT',
        'Metro',
        4,
        '{"abbreviation": "m"}',
        'system'
    ),
    (
        'UNIT_OF_MEASURE',
        'M2',
        'Metro Cuadrado',
        5,
        '{"abbreviation": "m²"}',
        'system'
    ),
    (
        'UNIT_OF_MEASURE',
        'CJ',
        'Caja',
        6,
        '{"abbreviation": "cj"}',
        'system'
    );

INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        created_by
    )
VALUES (
        'PRODUCT_TYPE',
        'PHYSICAL',
        'Producto Físico',
        1,
        'system'
    ),
    (
        'PRODUCT_TYPE',
        'SERVICE',
        'Servicio',
        2,
        'system'
    );

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
        'MOVEMENT_TYPE',
        'IN',
        'Entrada',
        1,
        '{"affectsStock": 1}',
        'system'
    ),
    (
        'MOVEMENT_TYPE',
        'OUT',
        'Salida',
        2,
        '{"affectsStock": -1}',
        'system'
    ),
    (
        'MOVEMENT_TYPE',
        'ADJUST',
        'Ajuste',
        3,
        '{"affectsStock": 0}',
        'system'
    );

-- ==================== 6. DOCUMENTS & STATES ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'DOCUMENT_STATUS',
        'Estados de Documento',
        'Pendiente, aprobado, rechazado, etc.',
        'STATIC',
        'system'
    ),
    (
        'TRANSACTION_TYPE',
        'Tipos de Transacción',
        'Tipos de operación del sistema',
        'STATIC',
        'system'
    ),
    (
        'ANNULMENT_REASON',
        'Motivos de Anulación',
        'Razones para anular documentos',
        'DYNAMIC',
        'system'
    );

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
        'DOCUMENT_STATUS',
        'DRAFT',
        'Borrador',
        1,
        '{"color": "#9CA3AF"}',
        'system'
    ),
    (
        'DOCUMENT_STATUS',
        'PENDING',
        'Pendiente',
        2,
        '{"color": "#F59E0B"}',
        'system'
    ),
    (
        'DOCUMENT_STATUS',
        'APPROVED',
        'Aprobado',
        3,
        '{"color": "#10B981"}',
        'system'
    ),
    (
        'DOCUMENT_STATUS',
        'REJECTED',
        'Rechazado',
        4,
        '{"color": "#EF4444"}',
        'system'
    ),
    (
        'DOCUMENT_STATUS',
        'CANCELLED',
        'Anulado',
        5,
        '{"color": "#6B7280"}',
        'system'
    );

-- ==================== 7. BUSINESS FUNCTIONAL ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'CONTRACT_TYPE',
        'Tipos de Contrato',
        'Tipos de contrato laboral',
        'STATIC',
        'system'
    ),
    (
        'CLIENT_TYPE',
        'Tipos de Cliente',
        'Clasificación de clientes',
        'DYNAMIC',
        'system'
    ),
    (
        'MARKET_SEGMENT',
        'Segmentos de Mercado',
        'Segmentación comercial',
        'DYNAMIC',
        'system'
    ),
    (
        'SUPPLIER_CLASS',
        'Clasificación de Proveedores',
        'Tipos de proveedor',
        'DYNAMIC',
        'system'
    ),
    (
        'PRIORITY',
        'Prioridades',
        'Niveles de prioridad',
        'STATIC',
        'system'
    ),
    (
        'SALES_CHANNEL',
        'Canales de Venta',
        'Canales comerciales',
        'DYNAMIC',
        'system'
    );

INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        created_by
    )
VALUES (
        'CONTRACT_TYPE',
        'FIXED',
        'Término Fijo',
        1,
        'system'
    ),
    (
        'CONTRACT_TYPE',
        'INDEFINITE',
        'Término Indefinido',
        2,
        'system'
    ),
    (
        'CONTRACT_TYPE',
        'SERVICE',
        'Prestación de Servicios',
        3,
        'system'
    ),
    (
        'CONTRACT_TYPE',
        'APPRENTICE',
        'Aprendizaje',
        4,
        'system'
    );

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
        'PRIORITY',
        'LOW',
        'Baja',
        1,
        '{"color": "#6B7280", "weight": 1}',
        'system'
    ),
    (
        'PRIORITY',
        'MEDIUM',
        'Media',
        2,
        '{"color": "#F59E0B", "weight": 2}',
        'system'
    ),
    (
        'PRIORITY',
        'HIGH',
        'Alta',
        3,
        '{"color": "#EF4444", "weight": 3}',
        'system'
    ),
    (
        'PRIORITY',
        'CRITICAL',
        'Crítica',
        4,
        '{"color": "#7C3AED", "weight": 4}',
        'system'
    );

-- ==================== 8. TIME & CALENDARS ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'WORK_SHIFT',
        'Jornadas',
        'Horarios laborales',
        'DYNAMIC',
        'system'
    ),
    (
        'ACCOUNTING_PERIOD',
        'Períodos Contables',
        'Períodos de cierre contable',
        'DYNAMIC',
        'system'
    );

-- ==================== 9. LOGISTICS ====================
INSERT INTO
    catalog (
        code,
        name,
        description,
        type,
        created_by
    )
VALUES (
        'TRANSPORT_TYPE',
        'Tipos de Transporte',
        'Terrestre, aéreo, marítimo',
        'STATIC',
        'system'
    ),
    (
        'SHIPPING_ZONE',
        'Zonas de Envío',
        'Zonas geográficas de despacho',
        'DYNAMIC',
        'system'
    ),
    (
        'INCOTERM',
        'Incoterms',
        'Términos de comercio internacional',
        'STATIC',
        'system'
    );

INSERT INTO
    catalog_item (
        catalog_code,
        item_code,
        name,
        order_index,
        created_by
    )
VALUES (
        'TRANSPORT_TYPE',
        'GROUND',
        'Terrestre',
        1,
        'system'
    ),
    (
        'TRANSPORT_TYPE',
        'AIR',
        'Aéreo',
        2,
        'system'
    ),
    (
        'TRANSPORT_TYPE',
        'SEA',
        'Marítimo',
        3,
        'system'
    );

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
        'INCOTERM',
        'EXW',
        'Ex Works',
        1,
        '{"responsibility": "buyer"}',
        'system'
    ),
    (
        'INCOTERM',
        'FOB',
        'Free On Board',
        2,
        '{"responsibility": "shared"}',
        'system'
    ),
    (
        'INCOTERM',
        'CIF',
        'Cost, Insurance & Freight',
        3,
        '{"responsibility": "seller"}',
        'system'
    ),
    (
        'INCOTERM',
        'DDP',
        'Delivered Duty Paid',
        4,
        '{"responsibility": "seller"}',
        'system'
    );