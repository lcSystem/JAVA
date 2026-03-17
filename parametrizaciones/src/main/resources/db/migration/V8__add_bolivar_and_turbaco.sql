-- Add Bolívar department
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, 'BOL', 'Bolívar', 6, '{"daneCode": "13"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';

-- Add Cities to Bolívar
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, 'CTG', 'Cartagena', 1, '{"daneCode": "13001", "latitude": 10.3910, "longitude": -75.4794}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = 'BOL';

INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, 'TUR', 'Turbaco', 2, '{"daneCode": "13836", "latitude": 10.3323, "longitude": -75.4095}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = 'BOL';
