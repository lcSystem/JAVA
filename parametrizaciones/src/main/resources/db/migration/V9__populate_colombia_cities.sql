-- ============================================================
-- V9: Populate Complete Colombia Cities from DANE DIVIPOLA
-- ============================================================

-- 1. Clean existing DEPARTMENTS and CITIES for Colombia to avoid duplicates
DELETE FROM catalog_item 
WHERE catalog_code = 'CITY' AND parent_id IN (
    SELECT id FROM (
        SELECT id FROM catalog_item 
        WHERE catalog_code = 'DEPARTMENT' AND parent_id = (
            SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO'
        )
    ) as temp
);

DELETE FROM catalog_item 
WHERE catalog_code = 'DEPARTMENT' AND parent_id = (
    SELECT id FROM (
        SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO'
    ) as temp
);

-- 2. Insert all 32 Departments
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '05', 'Antioquia', 1, '{"daneCode": "05"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '08', 'Atlántico', 2, '{"daneCode": "08"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '11', 'Bogotá, D.C.', 3, '{"daneCode": "11"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '13', 'Bolívar', 4, '{"daneCode": "13"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '15', 'Boyacá', 5, '{"daneCode": "15"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '17', 'Caldas', 6, '{"daneCode": "17"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '18', 'Caquetá', 7, '{"daneCode": "18"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '19', 'Cauca', 8, '{"daneCode": "19"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '20', 'Cesar', 9, '{"daneCode": "20"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '23', 'Córdoba', 10, '{"daneCode": "23"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '25', 'Cundinamarca', 11, '{"daneCode": "25"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '27', 'Chocó', 12, '{"daneCode": "27"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '41', 'Huila', 13, '{"daneCode": "41"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '44', 'La Guajira', 14, '{"daneCode": "44"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '47', 'Magdalena', 15, '{"daneCode": "47"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '50', 'Meta', 16, '{"daneCode": "50"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '52', 'Nariño', 17, '{"daneCode": "52"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '54', 'Norte De Santander', 18, '{"daneCode": "54"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '63', 'Quindío', 19, '{"daneCode": "63"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '66', 'Risaralda', 20, '{"daneCode": "66"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '68', 'Santander', 21, '{"daneCode": "68"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '70', 'Sucre', 22, '{"daneCode": "70"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '73', 'Tolima', 23, '{"daneCode": "73"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '76', 'Valle Del Cauca', 24, '{"daneCode": "76"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '81', 'Arauca', 25, '{"daneCode": "81"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '85', 'Casanare', 26, '{"daneCode": "85"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '86', 'Putumayo', 27, '{"daneCode": "86"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '88', 'Archipiélago De San Andrés, Providencia Y Santa Catalina', 28, '{"daneCode": "88"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '91', 'Amazonas', 29, '{"daneCode": "91"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '94', 'Guainía', 30, '{"daneCode": "94"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '95', 'Guaviare', 31, '{"daneCode": "95"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '97', 'Vaupés', 32, '{"daneCode": "97"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'DEPARTMENT', id, '99', 'Vichada', 33, '{"daneCode": "99"}', 'system'
FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO';

-- 3. Insert all 1122 Cities
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05001', 'Medellín', 1, '{"daneCode": "05001", "latitude": 6.246631, "longitude": -75.581775}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05002', 'Abejorral', 2, '{"daneCode": "05002", "latitude": 5.789315, "longitude": -75.428739}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05004', 'Abriaquí', 3, '{"daneCode": "05004", "latitude": 6.632282, "longitude": -76.064304}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05021', 'Alejandría', 4, '{"daneCode": "05021", "latitude": 6.376061, "longitude": -75.141346}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05030', 'Amagá', 5, '{"daneCode": "05030", "latitude": 6.038708, "longitude": -75.702188}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05031', 'Amalfi', 6, '{"daneCode": "05031", "latitude": 6.909655, "longitude": -75.077501}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05034', 'Andes', 7, '{"daneCode": "05034", "latitude": 5.657194, "longitude": -75.878828}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05036', 'Angelópolis', 8, '{"daneCode": "05036", "latitude": 6.109719, "longitude": -75.711389}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05038', 'Angostura', 9, '{"daneCode": "05038", "latitude": 6.885175, "longitude": -75.335116}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05040', 'Anorí', 10, '{"daneCode": "05040", "latitude": 7.074703, "longitude": -75.148355}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05042', 'Santa Fé De Antioquia', 11, '{"daneCode": "05042", "latitude": 6.556484, "longitude": -75.826648}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05044', 'Anzá', 12, '{"daneCode": "05044", "latitude": 6.302641, "longitude": -75.854442}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05045', 'Apartadó', 13, '{"daneCode": "05045", "latitude": 7.882968, "longitude": -76.625279}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05051', 'Arboletes', 14, '{"daneCode": "05051", "latitude": 8.849317, "longitude": -76.426708}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05055', 'Argelia', 15, '{"daneCode": "05055", "latitude": 5.731474, "longitude": -75.141070}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05059', 'Armenia', 16, '{"daneCode": "05059", "latitude": 6.155667, "longitude": -75.786647}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05079', 'Barbosa', 17, '{"daneCode": "05079", "latitude": 6.439195, "longitude": -75.331627}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05086', 'Belmira', 18, '{"daneCode": "05086", "latitude": 6.606319, "longitude": -75.667779}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05088', 'Bello', 19, '{"daneCode": "05088", "latitude": 6.333587, "longitude": -75.555245}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05091', 'Betania', 20, '{"daneCode": "05091", "latitude": 5.746150, "longitude": -75.976790}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05093', 'Betulia', 21, '{"daneCode": "05093", "latitude": 6.115208, "longitude": -75.984452}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05101', 'Ciudad Bolívar', 22, '{"daneCode": "05101", "latitude": 5.850273, "longitude": -76.021509}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05107', 'Briceño', 23, '{"daneCode": "05107", "latitude": 7.112803, "longitude": -75.550360}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05113', 'Buriticá', 24, '{"daneCode": "05113", "latitude": 6.720759, "longitude": -75.907000}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05120', 'Cáceres', 25, '{"daneCode": "05120", "latitude": 7.578366, "longitude": -75.352050}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05125', 'Caicedo', 26, '{"daneCode": "05125", "latitude": 6.405607, "longitude": -75.982930}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05129', 'Caldas', 27, '{"daneCode": "05129", "latitude": 6.091077, "longitude": -75.633673}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05134', 'Campamento', 28, '{"daneCode": "05134", "latitude": 6.979771, "longitude": -75.298091}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05138', 'Cañasgordas', 29, '{"daneCode": "05138", "latitude": 6.753859, "longitude": -76.028228}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05142', 'Caracolí', 30, '{"daneCode": "05142", "latitude": 6.409829, "longitude": -74.757421}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05145', 'Caramanta', 31, '{"daneCode": "05145", "latitude": 5.548530, "longitude": -75.643868}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05147', 'Carepa', 32, '{"daneCode": "05147", "latitude": 7.755148, "longitude": -76.652652}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05148', 'El Carmen De Viboral', 33, '{"daneCode": "05148", "latitude": 6.082885, "longitude": -75.333901}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05150', 'Carolina', 34, '{"daneCode": "05150", "latitude": 6.725995, "longitude": -75.283192}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05154', 'Caucasia', 35, '{"daneCode": "05154", "latitude": 7.977278, "longitude": -75.197996}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05172', 'Chigorodó', 36, '{"daneCode": "05172", "latitude": 7.666147, "longitude": -76.681531}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05190', 'Cisneros', 37, '{"daneCode": "05190", "latitude": 6.537829, "longitude": -75.087047}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05197', 'Cocorná', 38, '{"daneCode": "05197", "latitude": 6.058295, "longitude": -75.185483}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05206', 'Concepción', 39, '{"daneCode": "05206", "latitude": 6.394348, "longitude": -75.257587}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05209', 'Concordia', 40, '{"daneCode": "05209", "latitude": 6.045738, "longitude": -75.908448}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05212', 'Copacabana', 41, '{"daneCode": "05212", "latitude": 6.348557, "longitude": -75.509384}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05234', 'Dabeiba', 42, '{"daneCode": "05234", "latitude": 6.998112, "longitude": -76.261614}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05237', 'Donmatías', 43, '{"daneCode": "05237", "latitude": 6.485603, "longitude": -75.392630}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05240', 'Ebéjico', 44, '{"daneCode": "05240", "latitude": 6.325615, "longitude": -75.766413}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05250', 'El Bagre', 45, '{"daneCode": "05250", "latitude": 7.597500, "longitude": -74.799097}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05264', 'Entrerríos', 46, '{"daneCode": "05264", "latitude": 6.566273, "longitude": -75.517685}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05266', 'Envigado', 47, '{"daneCode": "05266", "latitude": 6.166695, "longitude": -75.582192}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05282', 'Fredonia', 48, '{"daneCode": "05282", "latitude": 5.928039, "longitude": -75.675072}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05284', 'Frontino', 49, '{"daneCode": "05284", "latitude": 6.776066, "longitude": -76.130765}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05306', 'Giraldo', 50, '{"daneCode": "05306", "latitude": 6.680808, "longitude": -75.952158}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05308', 'Girardota', 51, '{"daneCode": "05308", "latitude": 6.379472, "longitude": -75.444238}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05310', 'Gómez Plata', 52, '{"daneCode": "05310", "latitude": 6.683269, "longitude": -75.220018}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05313', 'Granada', 53, '{"daneCode": "05313", "latitude": 6.142892, "longitude": -75.184446}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05315', 'Guadalupe', 54, '{"daneCode": "05315", "latitude": 6.815069, "longitude": -75.239862}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05318', 'Guarne', 55, '{"daneCode": "05318", "latitude": 6.277870, "longitude": -75.441612}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05321', 'Guatapé', 56, '{"daneCode": "05321", "latitude": 6.232461, "longitude": -75.160041}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05347', 'Heliconia', 57, '{"daneCode": "05347", "latitude": 6.206757, "longitude": -75.734322}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05353', 'Hispania', 58, '{"daneCode": "05353", "latitude": 5.799461, "longitude": -75.906587}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05360', 'Itagüí', 59, '{"daneCode": "05360", "latitude": 6.175079, "longitude": -75.612056}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05361', 'Ituango', 60, '{"daneCode": "05361", "latitude": 7.171629, "longitude": -75.764673}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05364', 'Jardín', 61, '{"daneCode": "05364", "latitude": 5.597542, "longitude": -75.818982}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05368', 'Jericó', 62, '{"daneCode": "05368", "latitude": 5.789748, "longitude": -75.785499}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05376', 'La Ceja', 63, '{"daneCode": "05376", "latitude": 6.028062, "longitude": -75.429433}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05380', 'La Estrella', 64, '{"daneCode": "05380", "latitude": 6.145238, "longitude": -75.637708}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05390', 'La Pintada', 65, '{"daneCode": "05390", "latitude": 5.743808, "longitude": -75.607810}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05400', 'La Unión', 66, '{"daneCode": "05400", "latitude": 5.973845, "longitude": -75.360874}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05411', 'Liborina', 67, '{"daneCode": "05411", "latitude": 6.677316, "longitude": -75.812838}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05425', 'Maceo', 68, '{"daneCode": "05425", "latitude": 6.552116, "longitude": -74.787160}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05440', 'Marinilla', 69, '{"daneCode": "05440", "latitude": 6.173995, "longitude": -75.339345}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05467', 'Montebello', 70, '{"daneCode": "05467", "latitude": 5.946313, "longitude": -75.523455}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05475', 'Murindó', 71, '{"daneCode": "05475", "latitude": 6.977710, "longitude": -76.817485}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05480', 'Mutatá', 72, '{"daneCode": "05480", "latitude": 7.242875, "longitude": -76.435875}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05483', 'Nariño', 73, '{"daneCode": "05483", "latitude": 5.610777, "longitude": -75.176262}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05490', 'Necoclí', 74, '{"daneCode": "05490", "latitude": 8.434526, "longitude": -76.787271}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05495', 'Nechí', 75, '{"daneCode": "05495", "latitude": 8.094129, "longitude": -74.776470}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05501', 'Olaya', 76, '{"daneCode": "05501", "latitude": 6.626492, "longitude": -75.811773}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05541', 'Peñol', 77, '{"daneCode": "05541", "latitude": 6.219349, "longitude": -75.242693}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05543', 'Peque', 78, '{"daneCode": "05543", "latitude": 7.021029, "longitude": -75.910357}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05576', 'Pueblorrico', 79, '{"daneCode": "05576", "latitude": 5.791580, "longitude": -75.839903}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05579', 'Puerto Berrío', 80, '{"daneCode": "05579", "latitude": 6.487028, "longitude": -74.410016}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05585', 'Puerto Nare', 81, '{"daneCode": "05585", "latitude": 6.186025, "longitude": -74.583012}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05591', 'Puerto Triunfo', 82, '{"daneCode": "05591", "latitude": 5.871318, "longitude": -74.641190}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05604', 'Remedios', 83, '{"daneCode": "05604", "latitude": 7.029424, "longitude": -74.698135}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05607', 'Retiro', 84, '{"daneCode": "05607", "latitude": 6.062454, "longitude": -75.501301}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05615', 'Rionegro', 85, '{"daneCode": "05615", "latitude": 6.147148, "longitude": -75.377316}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05628', 'Sabanalarga', 86, '{"daneCode": "05628", "latitude": 6.850028, "longitude": -75.816645}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05631', 'Sabaneta', 87, '{"daneCode": "05631", "latitude": 6.149903, "longitude": -75.615479}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05642', 'Salgar', 88, '{"daneCode": "05642", "latitude": 5.964198, "longitude": -75.976807}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05647', 'San Andrés De Cuerquía', 89, '{"daneCode": "05647", "latitude": 6.916676, "longitude": -75.674564}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05649', 'San Carlos', 90, '{"daneCode": "05649", "latitude": 6.187746, "longitude": -74.988097}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05652', 'San Francisco', 91, '{"daneCode": "05652", "latitude": 5.963476, "longitude": -75.101562}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05656', 'San Jerónimo', 92, '{"daneCode": "05656", "latitude": 6.448090, "longitude": -75.726975}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05658', 'San José De La Montaña', 93, '{"daneCode": "05658", "latitude": 6.850090, "longitude": -75.683352}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05659', 'San Juan De Urabá', 94, '{"daneCode": "05659", "latitude": 8.758964, "longitude": -76.528570}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05660', 'San Luis', 95, '{"daneCode": "05660", "latitude": 6.043017, "longitude": -74.993619}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05664', 'San Pedro De Los Milagros', 96, '{"daneCode": "05664", "latitude": 6.460120, "longitude": -75.556743}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05665', 'San Pedro De Urabá', 97, '{"daneCode": "05665", "latitude": 8.276884, "longitude": -76.380567}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05667', 'San Rafael', 98, '{"daneCode": "05667", "latitude": 6.293759, "longitude": -75.028490}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05670', 'San Roque', 99, '{"daneCode": "05670", "latitude": 6.485939, "longitude": -75.019109}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05674', 'San Vicente Ferrer', 100, '{"daneCode": "05674", "latitude": 6.282164, "longitude": -75.332616}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05679', 'Santa Bárbara', 101, '{"daneCode": "05679", "latitude": 5.875527, "longitude": -75.567351}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05686', 'Santa Rosa De Osos', 102, '{"daneCode": "05686", "latitude": 6.643366, "longitude": -75.460723}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05690', 'Santo Domingo', 103, '{"daneCode": "05690", "latitude": 6.473032, "longitude": -75.164903}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05697', 'El Santuario', 104, '{"daneCode": "05697", "latitude": 6.136871, "longitude": -75.265465}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05736', 'Segovia', 105, '{"daneCode": "05736", "latitude": 7.079648, "longitude": -74.701596}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05756', 'Sonsón', 106, '{"daneCode": "05756", "latitude": 5.714851, "longitude": -75.309596}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05761', 'Sopetrán', 107, '{"daneCode": "05761", "latitude": 6.500745, "longitude": -75.747378}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05789', 'Támesis', 108, '{"daneCode": "05789", "latitude": 5.664645, "longitude": -75.714429}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05790', 'Tarazá', 109, '{"daneCode": "05790", "latitude": 7.580127, "longitude": -75.401407}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05792', 'Tarso', 110, '{"daneCode": "05792", "latitude": 5.864542, "longitude": -75.822956}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05809', 'Titiribí', 111, '{"daneCode": "05809", "latitude": 6.062391, "longitude": -75.791887}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05819', 'Toledo', 112, '{"daneCode": "05819", "latitude": 7.010328, "longitude": -75.692281}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05837', 'Turbo', 113, '{"daneCode": "05837", "latitude": 8.089929, "longitude": -76.728858}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05842', 'Uramita', 114, '{"daneCode": "05842", "latitude": 6.898393, "longitude": -76.173284}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05847', 'Urrao', 115, '{"daneCode": "05847", "latitude": 6.317343, "longitude": -76.133951}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05854', 'Valdivia', 116, '{"daneCode": "05854", "latitude": 7.165200, "longitude": -75.439274}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05856', 'Valparaíso', 117, '{"daneCode": "05856", "latitude": 5.614555, "longitude": -75.624452}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05858', 'Vegachí', 118, '{"daneCode": "05858", "latitude": 6.773525, "longitude": -74.798714}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05861', 'Venecia', 119, '{"daneCode": "05861", "latitude": 5.964693, "longitude": -75.735544}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05873', 'Vigía Del Fuerte', 120, '{"daneCode": "05873", "latitude": 6.588164, "longitude": -76.896004}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05885', 'Yalí', 121, '{"daneCode": "05885", "latitude": 6.676554, "longitude": -74.840059}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05887', 'Yarumal', 122, '{"daneCode": "05887", "latitude": 6.963832, "longitude": -75.418828}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05890', 'Yolombó', 123, '{"daneCode": "05890", "latitude": 6.594511, "longitude": -75.013385}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05893', 'Yondó', 124, '{"daneCode": "05893", "latitude": 7.003960, "longitude": -73.912445}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '05895', 'Zaragoza', 125, '{"daneCode": "05895", "latitude": 7.488583, "longitude": -74.867075}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '05'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08001', 'Barranquilla', 126, '{"daneCode": "08001", "latitude": 10.977961, "longitude": -74.815546}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08078', 'Baranoa', 127, '{"daneCode": "08078", "latitude": 10.794450, "longitude": -74.916077}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08137', 'Campo De La Cruz', 128, '{"daneCode": "08137", "latitude": 10.378291, "longitude": -74.880847}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08141', 'Candelaria', 129, '{"daneCode": "08141", "latitude": 10.461903, "longitude": -74.879717}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08296', 'Galapa', 130, '{"daneCode": "08296", "latitude": 10.919033, "longitude": -74.870385}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08372', 'Juan De Acosta', 131, '{"daneCode": "08372", "latitude": 10.832540, "longitude": -75.041032}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08421', 'Luruaco', 132, '{"daneCode": "08421", "latitude": 10.610491, "longitude": -75.141990}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08433', 'Malambo', 133, '{"daneCode": "08433", "latitude": 10.857086, "longitude": -74.776923}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08436', 'Manatí', 134, '{"daneCode": "08436", "latitude": 10.449089, "longitude": -74.956867}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08520', 'Palmar De Varela', 135, '{"daneCode": "08520", "latitude": 10.738591, "longitude": -74.754765}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08549', 'Piojó', 136, '{"daneCode": "08549", "latitude": 10.749216, "longitude": -75.107592}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08558', 'Polonuevo', 137, '{"daneCode": "08558", "latitude": 10.777363, "longitude": -74.852981}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08560', 'Ponedera', 138, '{"daneCode": "08560", "latitude": 10.641779, "longitude": -74.753885}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08573', 'Puerto Colombia', 139, '{"daneCode": "08573", "latitude": 11.015322, "longitude": -74.888627}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08606', 'Repelón', 140, '{"daneCode": "08606", "latitude": 10.493357, "longitude": -75.125534}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08634', 'Sabanagrande', 141, '{"daneCode": "08634", "latitude": 10.792453, "longitude": -74.759496}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08638', 'Sabanalarga', 142, '{"daneCode": "08638", "latitude": 10.632091, "longitude": -74.921256}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08675', 'Santa Lucía', 143, '{"daneCode": "08675", "latitude": 10.324303, "longitude": -74.959204}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08685', 'Santo Tomás', 144, '{"daneCode": "08685", "latitude": 10.758735, "longitude": -74.757859}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08758', 'Soledad', 145, '{"daneCode": "08758", "latitude": 10.909921, "longitude": -74.786054}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08770', 'Suan', 146, '{"daneCode": "08770", "latitude": 10.335432, "longitude": -74.881687}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08832', 'Tubará', 147, '{"daneCode": "08832", "latitude": 10.873586, "longitude": -74.978704}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '08849', 'Usiacurí', 148, '{"daneCode": "08849", "latitude": 10.742980, "longitude": -74.976985}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '08'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '11001', 'Bogotá, D.C.', 149, '{"daneCode": "11001", "latitude": 4.649251, "longitude": -74.106992}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '11'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13001', 'Cartagena De Indias', 150, '{"daneCode": "13001", "latitude": 10.385126, "longitude": -75.496269}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13006', 'Achí', 151, '{"daneCode": "13006", "latitude": 8.570107, "longitude": -74.557676}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13030', 'Altos Del Rosario', 152, '{"daneCode": "13030", "latitude": 8.791865, "longitude": -74.164905}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13042', 'Arenal', 153, '{"daneCode": "13042", "latitude": 8.458865, "longitude": -73.941099}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13052', 'Arjona', 154, '{"daneCode": "13052", "latitude": 10.256660, "longitude": -75.344332}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13062', 'Arroyohondo', 155, '{"daneCode": "13062", "latitude": 10.250075, "longitude": -75.019215}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13074', 'Barranco De Loba', 156, '{"daneCode": "13074", "latitude": 8.947787, "longitude": -74.104391}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13140', 'Calamar', 157, '{"daneCode": "13140", "latitude": 10.250431, "longitude": -74.916144}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13160', 'Cantagallo', 158, '{"daneCode": "13160", "latitude": 7.378678, "longitude": -73.914605}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13188', 'Cicuco', 159, '{"daneCode": "13188", "latitude": 9.274281, "longitude": -74.645981}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13212', 'Córdoba', 160, '{"daneCode": "13212", "latitude": 9.586942, "longitude": -74.827399}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13222', 'Clemencia', 161, '{"daneCode": "13222", "latitude": 10.567452, "longitude": -75.328469}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13244', 'El Carmen De Bolívar', 162, '{"daneCode": "13244", "latitude": 9.718653, "longitude": -75.121178}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13248', 'El Guamo', 163, '{"daneCode": "13248", "latitude": 10.030958, "longitude": -74.976084}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13268', 'El Peñón', 164, '{"daneCode": "13268", "latitude": 8.988271, "longitude": -73.949274}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13300', 'Hatillo De Loba', 165, '{"daneCode": "13300", "latitude": 8.956014, "longitude": -74.077912}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13430', 'Magangué', 166, '{"daneCode": "13430", "latitude": 9.263799, "longitude": -74.766742}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13433', 'Mahates', 167, '{"daneCode": "13433", "latitude": 10.233285, "longitude": -75.191643}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13440', 'Margarita', 168, '{"daneCode": "13440", "latitude": 9.157840, "longitude": -74.285137}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13442', 'María La Baja', 169, '{"daneCode": "13442", "latitude": 9.982402, "longitude": -75.300516}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13458', 'Montecristo', 170, '{"daneCode": "13458", "latitude": 8.297234, "longitude": -74.471176}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13468', 'Santa Cruz De Mompox', 171, '{"daneCode": "13468", "latitude": 9.244241, "longitude": -74.428180}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13473', 'Morales', 172, '{"daneCode": "13473", "latitude": 8.276558, "longitude": -73.868172}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13490', 'Norosí', 173, '{"daneCode": "13490", "latitude": 8.526259, "longitude": -74.038003}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13549', 'Pinillos', 174, '{"daneCode": "13549", "latitude": 8.914947, "longitude": -74.462279}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13580', 'Regidor', 175, '{"daneCode": "13580", "latitude": 8.666258, "longitude": -73.821638}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13600', 'Río Viejo', 176, '{"daneCode": "13600", "latitude": 8.587950, "longitude": -73.840466}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13620', 'San Cristóbal', 177, '{"daneCode": "13620", "latitude": 10.392836, "longitude": -75.065076}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13647', 'San Estanislao', 178, '{"daneCode": "13647", "latitude": 10.398602, "longitude": -75.153101}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13650', 'San Fernando', 179, '{"daneCode": "13650", "latitude": 9.214183, "longitude": -74.323811}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13654', 'San Jacinto', 180, '{"daneCode": "13654", "latitude": 9.830275, "longitude": -75.121050}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13655', 'San Jacinto Del Cauca', 181, '{"daneCode": "13655", "latitude": 8.251580, "longitude": -74.721156}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13657', 'San Juan Nepomuceno', 182, '{"daneCode": "13657", "latitude": 9.953751, "longitude": -75.081761}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13667', 'San Martín De Loba', 183, '{"daneCode": "13667", "latitude": 8.937485, "longitude": -74.039134}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13670', 'San Pablo', 184, '{"daneCode": "13670", "latitude": 7.476747, "longitude": -73.924602}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13673', 'Santa Catalina', 185, '{"daneCode": "13673", "latitude": 10.605294, "longitude": -75.287855}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13683', 'Santa Rosa', 186, '{"daneCode": "13683", "latitude": 10.444396, "longitude": -75.369824}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13688', 'Santa Rosa Del Sur', 187, '{"daneCode": "13688", "latitude": 7.963938, "longitude": -74.052243}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13744', 'Simití', 188, '{"daneCode": "13744", "latitude": 7.953916, "longitude": -73.947264}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13760', 'Soplaviento', 189, '{"daneCode": "13760", "latitude": 10.388390, "longitude": -75.136404}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13780', 'Talaigua Nuevo', 190, '{"daneCode": "13780", "latitude": 9.304030, "longitude": -74.567479}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13810', 'Tiquisio', 191, '{"daneCode": "13810", "latitude": 8.558666, "longitude": -74.262922}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13836', 'Turbaco', 192, '{"daneCode": "13836", "latitude": 10.348316, "longitude": -75.427249}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13838', 'Turbaná', 193, '{"daneCode": "13838", "latitude": 10.274585, "longitude": -75.442650}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13873', 'Villanueva', 194, '{"daneCode": "13873", "latitude": 10.444089, "longitude": -75.275613}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '13894', 'Zambrano', 195, '{"daneCode": "13894", "latitude": 9.746306, "longitude": -74.817879}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '13'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15001', 'Tunja', 196, '{"daneCode": "15001", "latitude": 5.539880, "longitude": -73.355539}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15022', 'Almeida', 197, '{"daneCode": "15022", "latitude": 4.970857, "longitude": -73.378933}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15047', 'Aquitania', 198, '{"daneCode": "15047", "latitude": 5.518602, "longitude": -72.883990}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15051', 'Arcabuco', 199, '{"daneCode": "15051", "latitude": 5.755673, "longitude": -73.437503}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15087', 'Belén', 200, '{"daneCode": "15087", "latitude": 5.989230, "longitude": -72.911641}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15090', 'Berbeo', 201, '{"daneCode": "15090", "latitude": 5.227451, "longitude": -73.127210}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15092', 'Betéitiva', 202, '{"daneCode": "15092", "latitude": 5.909978, "longitude": -72.809014}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15097', 'Boavita', 203, '{"daneCode": "15097", "latitude": 6.330703, "longitude": -72.584905}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15104', 'Boyacá', 204, '{"daneCode": "15104", "latitude": 5.454578, "longitude": -73.361945}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15106', 'Briceño', 205, '{"daneCode": "15106", "latitude": 5.690879, "longitude": -73.923260}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15109', 'Buenavista', 206, '{"daneCode": "15109", "latitude": 5.512594, "longitude": -73.942170}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15114', 'Busbanzá', 207, '{"daneCode": "15114", "latitude": 5.831393, "longitude": -72.884158}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15131', 'Caldas', 208, '{"daneCode": "15131", "latitude": 5.554580, "longitude": -73.865553}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15135', 'Campohermoso', 209, '{"daneCode": "15135", "latitude": 5.031676, "longitude": -73.104173}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15162', 'Cerinza', 210, '{"daneCode": "15162", "latitude": 5.955939, "longitude": -72.947918}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15172', 'Chinavita', 211, '{"daneCode": "15172", "latitude": 5.167486, "longitude": -73.368476}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15176', 'Chiquinquirá', 212, '{"daneCode": "15176", "latitude": 5.613790, "longitude": -73.818745}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15180', 'Chiscas', 213, '{"daneCode": "15180", "latitude": 6.553136, "longitude": -72.500957}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15183', 'Chita', 214, '{"daneCode": "15183", "latitude": 6.187083, "longitude": -72.471892}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15185', 'Chitaraque', 215, '{"daneCode": "15185", "latitude": 6.027425, "longitude": -73.447100}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15187', 'Chivatá', 216, '{"daneCode": "15187", "latitude": 5.558949, "longitude": -73.282529}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15189', 'Ciénega', 217, '{"daneCode": "15189", "latitude": 5.408694, "longitude": -73.296049}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15204', 'Cómbita', 218, '{"daneCode": "15204", "latitude": 5.634545, "longitude": -73.323957}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15212', 'Coper', 219, '{"daneCode": "15212", "latitude": 5.475074, "longitude": -74.045636}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15215', 'Corrales', 220, '{"daneCode": "15215", "latitude": 5.828064, "longitude": -72.844795}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15218', 'Covarachía', 221, '{"daneCode": "15218", "latitude": 6.500177, "longitude": -72.738978}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15223', 'Cubará', 222, '{"daneCode": "15223", "latitude": 6.997275, "longitude": -72.107939}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15224', 'Cucaita', 223, '{"daneCode": "15224", "latitude": 5.544452, "longitude": -73.454338}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15226', 'Cuítiva', 224, '{"daneCode": "15226", "latitude": 5.580367, "longitude": -72.965923}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15232', 'Chíquiza', 225, '{"daneCode": "15232", "latitude": 5.639834, "longitude": -73.449463}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15236', 'Chivor', 226, '{"daneCode": "15236", "latitude": 4.888173, "longitude": -73.368398}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15238', 'Duitama', 227, '{"daneCode": "15238", "latitude": 5.822964, "longitude": -73.030630}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15244', 'El Cocuy', 228, '{"daneCode": "15244", "latitude": 6.407738, "longitude": -72.444537}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15248', 'El Espino', 229, '{"daneCode": "15248", "latitude": 6.483027, "longitude": -72.497007}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15272', 'Firavitoba', 230, '{"daneCode": "15272", "latitude": 5.668885, "longitude": -72.993392}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15276', 'Floresta', 231, '{"daneCode": "15276", "latitude": 5.859519, "longitude": -72.918111}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15293', 'Gachantivá', 232, '{"daneCode": "15293", "latitude": 5.751891, "longitude": -73.549092}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15296', 'Gámeza', 233, '{"daneCode": "15296", "latitude": 5.802333, "longitude": -72.805530}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15299', 'Garagoa', 234, '{"daneCode": "15299", "latitude": 5.083234, "longitude": -73.364413}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15317', 'Guacamayas', 235, '{"daneCode": "15317", "latitude": 6.459667, "longitude": -72.500812}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15322', 'Guateque', 236, '{"daneCode": "15322", "latitude": 5.007321, "longitude": -73.471207}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15325', 'Guayatá', 237, '{"daneCode": "15325", "latitude": 4.967122, "longitude": -73.489698}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15332', 'Güicán De La Sierra', 238, '{"daneCode": "15332", "latitude": 6.462864, "longitude": -72.411763}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15362', 'Iza', 239, '{"daneCode": "15362", "latitude": 5.611577, "longitude": -72.979559}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15367', 'Jenesano', 240, '{"daneCode": "15367", "latitude": 5.385813, "longitude": -73.363738}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15368', 'Jericó', 241, '{"daneCode": "15368", "latitude": 6.145735, "longitude": -72.571122}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15377', 'Labranzagrande', 242, '{"daneCode": "15377", "latitude": 5.562687, "longitude": -72.577770}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15380', 'La Capilla', 243, '{"daneCode": "15380", "latitude": 5.095687, "longitude": -73.444347}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15401', 'La Victoria', 244, '{"daneCode": "15401", "latitude": 5.523792, "longitude": -74.234393}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15403', 'La Uvita', 245, '{"daneCode": "15403", "latitude": 6.316160, "longitude": -72.559982}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15407', 'Villa De Leyva', 246, '{"daneCode": "15407", "latitude": 5.632455, "longitude": -73.524948}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15425', 'Macanal', 247, '{"daneCode": "15425", "latitude": 4.972464, "longitude": -73.319593}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15442', 'Maripí', 248, '{"daneCode": "15442", "latitude": 5.550091, "longitude": -74.004050}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15455', 'Miraflores', 249, '{"daneCode": "15455", "latitude": 5.196515, "longitude": -73.145630}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15464', 'Mongua', 250, '{"daneCode": "15464", "latitude": 5.754242, "longitude": -72.798090}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15466', 'Monguí', 251, '{"daneCode": "15466", "latitude": 5.723486, "longitude": -72.849292}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15469', 'Moniquirá', 252, '{"daneCode": "15469", "latitude": 5.876331, "longitude": -73.573374}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15476', 'Motavita', 253, '{"daneCode": "15476", "latitude": 5.577700, "longitude": -73.367841}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15480', 'Muzo', 254, '{"daneCode": "15480", "latitude": 5.532758, "longitude": -74.102690}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15491', 'Nobsa', 255, '{"daneCode": "15491", "latitude": 5.768046, "longitude": -72.937042}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15494', 'Nuevo Colón', 256, '{"daneCode": "15494", "latitude": 5.355317, "longitude": -73.456759}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15500', 'Oicatá', 257, '{"daneCode": "15500", "latitude": 5.595235, "longitude": -73.308399}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15507', 'Otanche', 258, '{"daneCode": "15507", "latitude": 5.657536, "longitude": -74.180965}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15511', 'Pachavita', 259, '{"daneCode": "15511", "latitude": 5.140065, "longitude": -73.396953}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15514', 'Páez', 260, '{"daneCode": "15514", "latitude": 5.097319, "longitude": -73.052737}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15516', 'Paipa', 261, '{"daneCode": "15516", "latitude": 5.779894, "longitude": -73.117820}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15518', 'Pajarito', 262, '{"daneCode": "15518", "latitude": 5.293783, "longitude": -72.703231}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15522', 'Panqueba', 263, '{"daneCode": "15522", "latitude": 6.443416, "longitude": -72.459424}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15531', 'Pauna', 264, '{"daneCode": "15531", "latitude": 5.656323, "longitude": -73.978449}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15533', 'Paya', 265, '{"daneCode": "15533", "latitude": 5.625699, "longitude": -72.423775}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15537', 'Paz De Río', 266, '{"daneCode": "15537", "latitude": 5.987645, "longitude": -72.749137}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15542', 'Pesca', 267, '{"daneCode": "15542", "latitude": 5.558808, "longitude": -73.050872}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15550', 'Pisba', 268, '{"daneCode": "15550", "latitude": 5.721410, "longitude": -72.486023}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15572', 'Puerto Boyacá', 269, '{"daneCode": "15572", "latitude": 5.976646, "longitude": -74.587782}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15580', 'Quípama', 270, '{"daneCode": "15580", "latitude": 5.520550, "longitude": -74.180033}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15599', 'Ramiriquí', 271, '{"daneCode": "15599", "latitude": 5.400303, "longitude": -73.334839}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15600', 'Ráquira', 272, '{"daneCode": "15600", "latitude": 5.539136, "longitude": -73.632543}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15621', 'Rondón', 273, '{"daneCode": "15621", "latitude": 5.357378, "longitude": -73.208474}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15632', 'Saboyá', 274, '{"daneCode": "15632", "latitude": 5.697756, "longitude": -73.764456}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15638', 'Sáchica', 275, '{"daneCode": "15638", "latitude": 5.584305, "longitude": -73.542539}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15646', 'Samacá', 276, '{"daneCode": "15646", "latitude": 5.492161, "longitude": -73.485589}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15660', 'San Eduardo', 277, '{"daneCode": "15660", "latitude": 5.224010, "longitude": -73.077747}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15664', 'San José De Pare', 278, '{"daneCode": "15664", "latitude": 6.018924, "longitude": -73.545397}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15667', 'San Luis De Gaceno', 279, '{"daneCode": "15667", "latitude": 4.819760, "longitude": -73.168076}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15673', 'San Mateo', 280, '{"daneCode": "15673", "latitude": 6.401683, "longitude": -72.555264}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15676', 'San Miguel De Sema', 281, '{"daneCode": "15676", "latitude": 5.518083, "longitude": -73.722009}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15681', 'San Pablo De Borbur', 282, '{"daneCode": "15681", "latitude": 5.650743, "longitude": -74.069963}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15686', 'Santana', 283, '{"daneCode": "15686", "latitude": 6.056866, "longitude": -73.481639}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15690', 'Santa María', 284, '{"daneCode": "15690", "latitude": 4.857193, "longitude": -73.263518}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15693', 'Santa Rosa De Viterbo', 285, '{"daneCode": "15693", "latitude": 5.874547, "longitude": -72.982461}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15696', 'Santa Sofía', 286, '{"daneCode": "15696", "latitude": 5.713269, "longitude": -73.602707}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15720', 'Sativanorte', 287, '{"daneCode": "15720", "latitude": 6.131132, "longitude": -72.708458}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15723', 'Sativasur', 288, '{"daneCode": "15723", "latitude": 6.093183, "longitude": -72.712435}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15740', 'Siachoque', 289, '{"daneCode": "15740", "latitude": 5.511811, "longitude": -73.244660}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15753', 'Soatá', 290, '{"daneCode": "15753", "latitude": 6.331945, "longitude": -72.684051}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15755', 'Socotá', 291, '{"daneCode": "15755", "latitude": 6.041162, "longitude": -72.636653}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15757', 'Socha', 292, '{"daneCode": "15757", "latitude": 5.996717, "longitude": -72.691963}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15759', 'Sogamoso', 293, '{"daneCode": "15759", "latitude": 5.723976, "longitude": -72.924355}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15761', 'Somondoco', 294, '{"daneCode": "15761", "latitude": 4.985726, "longitude": -73.433393}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15762', 'Sora', 295, '{"daneCode": "15762", "latitude": 5.566840, "longitude": -73.450153}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15763', 'Sotaquirá', 296, '{"daneCode": "15763", "latitude": 5.764986, "longitude": -73.246585}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15764', 'Soracá', 297, '{"daneCode": "15764", "latitude": 5.500898, "longitude": -73.332804}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15774', 'Susacón', 298, '{"daneCode": "15774", "latitude": 6.230332, "longitude": -72.690289}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15776', 'Sutamarchán', 299, '{"daneCode": "15776", "latitude": 5.619781, "longitude": -73.620536}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15778', 'Sutatenza', 300, '{"daneCode": "15778", "latitude": 5.022989, "longitude": -73.452317}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15790', 'Tasco', 301, '{"daneCode": "15790", "latitude": 5.909821, "longitude": -72.781011}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15798', 'Tenza', 302, '{"daneCode": "15798", "latitude": 5.076781, "longitude": -73.421176}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15804', 'Tibaná', 303, '{"daneCode": "15804", "latitude": 5.317251, "longitude": -73.396457}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15806', 'Tibasosa', 304, '{"daneCode": "15806", "latitude": 5.747230, "longitude": -72.999449}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15808', 'Tinjacá', 305, '{"daneCode": "15808", "latitude": 5.579713, "longitude": -73.646847}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15810', 'Tipacoque', 306, '{"daneCode": "15810", "latitude": 6.419203, "longitude": -72.691729}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15814', 'Toca', 307, '{"daneCode": "15814", "latitude": 5.566464, "longitude": -73.184794}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15816', 'Togüí', 308, '{"daneCode": "15816", "latitude": 5.937438, "longitude": -73.513655}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15820', 'Tópaga', 309, '{"daneCode": "15820", "latitude": 5.768201, "longitude": -72.832245}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15822', 'Tota', 310, '{"daneCode": "15822", "latitude": 5.560497, "longitude": -72.985898}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15832', 'Tununguá', 311, '{"daneCode": "15832", "latitude": 5.730582, "longitude": -73.933155}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15835', 'Turmequé', 312, '{"daneCode": "15835", "latitude": 5.323261, "longitude": -73.491825}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15837', 'Tuta', 313, '{"daneCode": "15837", "latitude": 5.689082, "longitude": -73.230285}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15839', 'Tutazá', 314, '{"daneCode": "15839", "latitude": 6.032608, "longitude": -72.856035}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15842', 'Úmbita', 315, '{"daneCode": "15842", "latitude": 5.221176, "longitude": -73.456917}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15861', 'Ventaquemada', 316, '{"daneCode": "15861", "latitude": 5.368739, "longitude": -73.522368}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15879', 'Viracachá', 317, '{"daneCode": "15879", "latitude": 5.436833, "longitude": -73.296894}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '15897', 'Zetaquira', 318, '{"daneCode": "15897", "latitude": 5.283443, "longitude": -73.170980}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '15'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17001', 'Manizales', 319, '{"daneCode": "17001", "latitude": 5.057657, "longitude": -75.491025}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17013', 'Aguadas', 320, '{"daneCode": "17013", "latitude": 5.610244, "longitude": -75.454870}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17042', 'Anserma', 321, '{"daneCode": "17042", "latitude": 5.236471, "longitude": -75.784343}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17050', 'Aranzazu', 322, '{"daneCode": "17050", "latitude": 5.271195, "longitude": -75.491290}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17088', 'Belalcázar', 323, '{"daneCode": "17088", "latitude": 4.993785, "longitude": -75.811918}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17174', 'Chinchiná', 324, '{"daneCode": "17174", "latitude": 4.985227, "longitude": -75.607529}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17272', 'Filadelfia', 325, '{"daneCode": "17272", "latitude": 5.297091, "longitude": -75.562474}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17380', 'La Dorada', 326, '{"daneCode": "17380", "latitude": 5.460834, "longitude": -74.668819}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17388', 'La Merced', 327, '{"daneCode": "17388", "latitude": 5.396470, "longitude": -75.546486}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17433', 'Manzanares', 328, '{"daneCode": "17433", "latitude": 5.255699, "longitude": -75.152829}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17442', 'Marmato', 329, '{"daneCode": "17442", "latitude": 5.474220, "longitude": -75.600049}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17444', 'Marquetalia', 330, '{"daneCode": "17444", "latitude": 5.297525, "longitude": -75.053097}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17446', 'Marulanda', 331, '{"daneCode": "17446", "latitude": 5.284304, "longitude": -75.259721}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17486', 'Neira', 332, '{"daneCode": "17486", "latitude": 5.166895, "longitude": -75.520006}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17495', 'Norcasia', 333, '{"daneCode": "17495", "latitude": 5.574796, "longitude": -74.889543}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17513', 'Pácora', 334, '{"daneCode": "17513", "latitude": 5.527172, "longitude": -75.459621}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17524', 'Palestina', 335, '{"daneCode": "17524", "latitude": 5.017879, "longitude": -75.624577}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17541', 'Pensilvania', 336, '{"daneCode": "17541", "latitude": 5.383281, "longitude": -75.160299}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17614', 'Riosucio', 337, '{"daneCode": "17614", "latitude": 5.423673, "longitude": -75.702104}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17616', 'Risaralda', 338, '{"daneCode": "17616", "latitude": 5.164509, "longitude": -75.767220}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17653', 'Salamina', 339, '{"daneCode": "17653", "latitude": 5.403025, "longitude": -75.487223}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17662', 'Samaná', 340, '{"daneCode": "17662", "latitude": 5.413080, "longitude": -74.992263}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17665', 'San José', 341, '{"daneCode": "17665", "latitude": 5.082310, "longitude": -75.792063}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17777', 'Supía', 342, '{"daneCode": "17777", "latitude": 5.446843, "longitude": -75.649660}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17867', 'Victoria', 343, '{"daneCode": "17867", "latitude": 5.317437, "longitude": -74.911239}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17873', 'Villamaría', 344, '{"daneCode": "17873", "latitude": 5.038925, "longitude": -75.502487}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '17877', 'Viterbo', 345, '{"daneCode": "17877", "latitude": 5.062664, "longitude": -75.870610}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '17'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18001', 'Florencia', 346, '{"daneCode": "18001", "latitude": 1.618196, "longitude": -75.609831}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18029', 'Albania', 347, '{"daneCode": "18029", "latitude": 1.328526, "longitude": -75.878375}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18094', 'Belén De Los Andaquíes', 348, '{"daneCode": "18094", "latitude": 1.415812, "longitude": -75.872405}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18150', 'Cartagena Del Chairá', 349, '{"daneCode": "18150", "latitude": 1.332371, "longitude": -74.847867}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18205', 'Curillo', 350, '{"daneCode": "18205", "latitude": 1.033473, "longitude": -75.919205}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18247', 'El Doncello', 351, '{"daneCode": "18247", "latitude": 1.679951, "longitude": -75.283631}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18256', 'El Paujíl', 352, '{"daneCode": "18256", "latitude": 1.570226, "longitude": -75.326093}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18410', 'La Montañita', 353, '{"daneCode": "18410", "latitude": 1.479173, "longitude": -75.436408}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18460', 'Milán', 354, '{"daneCode": "18460", "latitude": 1.290210, "longitude": -75.506926}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18479', 'Morelia', 355, '{"daneCode": "18479", "latitude": 1.486611, "longitude": -75.724146}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18592', 'Puerto Rico', 356, '{"daneCode": "18592", "latitude": 1.909063, "longitude": -75.157604}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18610', 'San José Del Fragua', 357, '{"daneCode": "18610", "latitude": 1.330266, "longitude": -75.973796}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18753', 'San Vicente Del Caguán', 358, '{"daneCode": "18753", "latitude": 2.119413, "longitude": -74.767894}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18756', 'Solano', 359, '{"daneCode": "18756", "latitude": 0.699077, "longitude": -75.253702}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18785', 'Solita', 360, '{"daneCode": "18785", "latitude": 0.876540, "longitude": -75.619902}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '18860', 'Valparaíso', 361, '{"daneCode": "18860", "latitude": 1.194619, "longitude": -75.706710}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '18'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19001', 'Popayán', 362, '{"daneCode": "19001", "latitude": 2.459641, "longitude": -76.599377}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19022', 'Almaguer', 363, '{"daneCode": "19022", "latitude": 1.913429, "longitude": -76.856070}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19050', 'Argelia', 364, '{"daneCode": "19050", "latitude": 2.257427, "longitude": -77.249050}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19075', 'Balboa', 365, '{"daneCode": "19075", "latitude": 2.040998, "longitude": -77.215773}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19100', 'Bolívar', 366, '{"daneCode": "19100", "latitude": 1.837538, "longitude": -76.966215}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19110', 'Buenos Aires', 367, '{"daneCode": "19110", "latitude": 3.015382, "longitude": -76.642238}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19130', 'Cajibío', 368, '{"daneCode": "19130", "latitude": 2.623371, "longitude": -76.570682}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19137', 'Caldono', 369, '{"daneCode": "19137", "latitude": 2.798059, "longitude": -76.484319}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19142', 'Caloto', 370, '{"daneCode": "19142", "latitude": 3.034531, "longitude": -76.408941}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19212', 'Corinto', 371, '{"daneCode": "19212", "latitude": 3.173854, "longitude": -76.261866}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19256', 'El Tambo', 372, '{"daneCode": "19256", "latitude": 2.451409, "longitude": -76.810911}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19290', 'Florencia', 373, '{"daneCode": "19290", "latitude": 1.682535, "longitude": -77.072547}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19300', 'Guachené', 374, '{"daneCode": "19300", "latitude": 3.134153, "longitude": -76.392189}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19318', 'Guapi', 375, '{"daneCode": "19318", "latitude": 2.571337, "longitude": -77.887970}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19355', 'Inzá', 376, '{"daneCode": "19355", "latitude": 2.549183, "longitude": -76.063503}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19364', 'Jambaló', 377, '{"daneCode": "19364", "latitude": 2.777834, "longitude": -76.323877}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19392', 'La Sierra', 378, '{"daneCode": "19392", "latitude": 2.179383, "longitude": -76.763278}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19397', 'La Vega', 379, '{"daneCode": "19397", "latitude": 2.001803, "longitude": -76.778771}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19418', 'López De Micay', 380, '{"daneCode": "19418", "latitude": 2.846788, "longitude": -77.247803}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19450', 'Mercaderes', 381, '{"daneCode": "19450", "latitude": 1.789193, "longitude": -77.164319}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19455', 'Miranda', 382, '{"daneCode": "19455", "latitude": 3.254651, "longitude": -76.228722}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19473', 'Morales', 383, '{"daneCode": "19473", "latitude": 2.754684, "longitude": -76.629106}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19513', 'Padilla', 384, '{"daneCode": "19513", "latitude": 3.220984, "longitude": -76.313265}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19517', 'Páez', 385, '{"daneCode": "19517", "latitude": 2.645724, "longitude": -75.970685}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19532', 'Patía', 386, '{"daneCode": "19532", "latitude": 2.115875, "longitude": -76.981075}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19533', 'Piamonte', 387, '{"daneCode": "19533", "latitude": 1.117540, "longitude": -76.327588}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19548', 'Piendamó - Tunía', 388, '{"daneCode": "19548", "latitude": 2.642280, "longitude": -76.528615}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19573', 'Puerto Tejada', 389, '{"daneCode": "19573", "latitude": 3.233254, "longitude": -76.417673}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19585', 'Puracé', 390, '{"daneCode": "19585", "latitude": 2.341507, "longitude": -76.496698}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19622', 'Rosas', 391, '{"daneCode": "19622", "latitude": 2.260941, "longitude": -76.740336}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19693', 'San Sebastián', 392, '{"daneCode": "19693", "latitude": 1.838451, "longitude": -76.769467}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19698', 'Santander De Quilichao', 393, '{"daneCode": "19698", "latitude": 3.015008, "longitude": -76.485141}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19701', 'Santa Rosa', 394, '{"daneCode": "19701", "latitude": 1.700916, "longitude": -76.573252}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19743', 'Silvia', 395, '{"daneCode": "19743", "latitude": 2.611927, "longitude": -76.379753}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19760', 'Sotará - Paispamba', 396, '{"daneCode": "19760", "latitude": 2.253156, "longitude": -76.613365}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19780', 'Suárez', 397, '{"daneCode": "19780", "latitude": 2.959785, "longitude": -76.693570}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19785', 'Sucre', 398, '{"daneCode": "19785", "latitude": 2.038237, "longitude": -76.926279}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19807', 'Timbío', 399, '{"daneCode": "19807", "latitude": 2.349686, "longitude": -76.684476}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19809', 'Timbiquí', 400, '{"daneCode": "19809", "latitude": 2.777312, "longitude": -77.667541}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19821', 'Toribío', 401, '{"daneCode": "19821", "latitude": 2.953017, "longitude": -76.270284}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19824', 'Totoró', 402, '{"daneCode": "19824", "latitude": 2.510252, "longitude": -76.403628}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '19845', 'Villa Rica', 403, '{"daneCode": "19845", "latitude": 3.177620, "longitude": -76.458025}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '19'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20001', 'Valledupar', 404, '{"daneCode": "20001", "latitude": 10.460472, "longitude": -73.259398}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20011', 'Aguachica', 405, '{"daneCode": "20011", "latitude": 8.306811, "longitude": -73.614027}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20013', 'Agustín Codazzi', 406, '{"daneCode": "20013", "latitude": 10.040454, "longitude": -73.238389}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20032', 'Astrea', 407, '{"daneCode": "20032", "latitude": 9.498062, "longitude": -73.975842}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20045', 'Becerril', 408, '{"daneCode": "20045", "latitude": 9.704404, "longitude": -73.278707}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20060', 'Bosconia', 409, '{"daneCode": "20060", "latitude": 9.975098, "longitude": -73.888761}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20175', 'Chimichagua', 410, '{"daneCode": "20175", "latitude": 9.258750, "longitude": -73.813278}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20178', 'Chiriguaná', 411, '{"daneCode": "20178", "latitude": 9.361058, "longitude": -73.599913}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20228', 'Curumaní', 412, '{"daneCode": "20228", "latitude": 9.201716, "longitude": -73.540843}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20238', 'El Copey', 413, '{"daneCode": "20238", "latitude": 10.149883, "longitude": -73.962703}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20250', 'El Paso', 414, '{"daneCode": "20250", "latitude": 9.668461, "longitude": -73.742012}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20295', 'Gamarra', 415, '{"daneCode": "20295", "latitude": 8.324793, "longitude": -73.737558}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20310', 'González', 416, '{"daneCode": "20310", "latitude": 8.389604, "longitude": -73.380040}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20383', 'La Gloria', 417, '{"daneCode": "20383", "latitude": 8.619298, "longitude": -73.803210}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20400', 'La Jagua De Ibirico', 418, '{"daneCode": "20400", "latitude": 9.563752, "longitude": -73.334143}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20443', 'Manaure Balcón Del Cesar', 419, '{"daneCode": "20443", "latitude": 10.390776, "longitude": -73.029472}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20517', 'Pailitas', 420, '{"daneCode": "20517", "latitude": 8.959399, "longitude": -73.625825}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20550', 'Pelaya', 421, '{"daneCode": "20550", "latitude": 8.689451, "longitude": -73.666735}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20570', 'Pueblo Bello', 422, '{"daneCode": "20570", "latitude": 10.417321, "longitude": -73.586211}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20614', 'Río De Oro', 423, '{"daneCode": "20614", "latitude": 8.292292, "longitude": -73.386393}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20621', 'La Paz', 424, '{"daneCode": "20621", "latitude": 10.387552, "longitude": -73.171365}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20710', 'San Alberto', 425, '{"daneCode": "20710", "latitude": 7.761110, "longitude": -73.393889}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20750', 'San Diego', 426, '{"daneCode": "20750", "latitude": 10.333039, "longitude": -73.181208}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20770', 'San Martín', 427, '{"daneCode": "20770", "latitude": 7.999855, "longitude": -73.510914}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '20787', 'Tamalameque', 428, '{"daneCode": "20787", "latitude": 8.861725, "longitude": -73.812172}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '20'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23001', 'Montería', 429, '{"daneCode": "23001", "latitude": 8.759789, "longitude": -75.873096}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23068', 'Ayapel', 430, '{"daneCode": "23068", "latitude": 8.313838, "longitude": -75.146048}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23079', 'Buenavista', 431, '{"daneCode": "23079", "latitude": 8.221187, "longitude": -75.480897}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23090', 'Canalete', 432, '{"daneCode": "23090", "latitude": 8.786939, "longitude": -76.241476}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23162', 'Cereté', 433, '{"daneCode": "23162", "latitude": 8.888532, "longitude": -75.796093}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23168', 'Chimá', 434, '{"daneCode": "23168", "latitude": 9.149698, "longitude": -75.626886}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23182', 'Chinú', 435, '{"daneCode": "23182", "latitude": 9.105473, "longitude": -75.399633}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23189', 'Ciénaga De Oro', 436, '{"daneCode": "23189", "latitude": 8.875794, "longitude": -75.620807}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23300', 'Cotorra', 437, '{"daneCode": "23300", "latitude": 9.037163, "longitude": -75.799216}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23350', 'La Apartada', 438, '{"daneCode": "23350", "latitude": 8.050125, "longitude": -75.336031}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23417', 'Lorica', 439, '{"daneCode": "23417", "latitude": 9.240789, "longitude": -75.816084}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23419', 'Los Córdobas', 440, '{"daneCode": "23419", "latitude": 8.892098, "longitude": -76.355180}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23464', 'Momil', 441, '{"daneCode": "23464", "latitude": 9.240707, "longitude": -75.677960}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23466', 'Montelíbano', 442, '{"daneCode": "23466", "latitude": 7.973777, "longitude": -75.416818}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23500', 'Moñitos', 443, '{"daneCode": "23500", "latitude": 9.245223, "longitude": -76.129100}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23555', 'Planeta Rica', 444, '{"daneCode": "23555", "latitude": 8.408200, "longitude": -75.583241}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23570', 'Pueblo Nuevo', 445, '{"daneCode": "23570", "latitude": 8.504099, "longitude": -75.508035}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23574', 'Puerto Escondido', 446, '{"daneCode": "23574", "latitude": 9.005372, "longitude": -76.260411}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23580', 'Puerto Libertador', 447, '{"daneCode": "23580", "latitude": 7.888859, "longitude": -75.671761}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23586', 'Purísima De La Concepción', 448, '{"daneCode": "23586", "latitude": 9.239295, "longitude": -75.724987}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23660', 'Sahagún', 449, '{"daneCode": "23660", "latitude": 8.943048, "longitude": -75.445834}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23670', 'San Andrés De Sotavento', 450, '{"daneCode": "23670", "latitude": 9.145448, "longitude": -75.508790}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23672', 'San Antero', 451, '{"daneCode": "23672", "latitude": 9.376434, "longitude": -75.761120}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23675', 'San Bernardo Del Viento', 452, '{"daneCode": "23675", "latitude": 9.352470, "longitude": -75.955107}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23678', 'San Carlos', 453, '{"daneCode": "23678", "latitude": 8.799282, "longitude": -75.698799}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23682', 'San José De Uré', 454, '{"daneCode": "23682", "latitude": 7.787303, "longitude": -75.533476}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23686', 'San Pelayo', 455, '{"daneCode": "23686", "latitude": 8.958436, "longitude": -75.835615}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23807', 'Tierralta', 456, '{"daneCode": "23807", "latitude": 8.170612, "longitude": -76.059797}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23815', 'Tuchín', 457, '{"daneCode": "23815", "latitude": 9.186625, "longitude": -75.553962}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '23855', 'Valencia', 458, '{"daneCode": "23855", "latitude": 8.255016, "longitude": -76.150756}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '23'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25001', 'Agua De Dios', 459, '{"daneCode": "25001", "latitude": 4.375309, "longitude": -74.669221}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25019', 'Albán', 460, '{"daneCode": "25019", "latitude": 4.878022, "longitude": -74.438261}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25035', 'Anapoima', 461, '{"daneCode": "25035", "latitude": 4.562737, "longitude": -74.528676}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25040', 'Anolaima', 462, '{"daneCode": "25040", "latitude": 4.761700, "longitude": -74.463840}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25053', 'Arbeláez', 463, '{"daneCode": "25053", "latitude": 4.272534, "longitude": -74.414901}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25086', 'Beltrán', 464, '{"daneCode": "25086", "latitude": 4.802832, "longitude": -74.741666}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25095', 'Bituima', 465, '{"daneCode": "25095", "latitude": 4.872171, "longitude": -74.539609}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25099', 'Bojacá', 466, '{"daneCode": "25099", "latitude": 4.737205, "longitude": -74.344594}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25120', 'Cabrera', 467, '{"daneCode": "25120", "latitude": 3.985164, "longitude": -74.484549}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25123', 'Cachipay', 468, '{"daneCode": "25123", "latitude": 4.730957, "longitude": -74.435711}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25126', 'Cajicá', 469, '{"daneCode": "25126", "latitude": 4.920009, "longitude": -74.022980}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25148', 'Caparrapí', 470, '{"daneCode": "25148", "latitude": 5.347580, "longitude": -74.491045}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25151', 'Cáqueza', 471, '{"daneCode": "25151", "latitude": 4.404112, "longitude": -73.946473}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25154', 'Carmen De Carupa', 472, '{"daneCode": "25154", "latitude": 5.349119, "longitude": -73.901357}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25168', 'Chaguaní', 473, '{"daneCode": "25168", "latitude": 4.948916, "longitude": -74.593455}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25175', 'Chía', 474, '{"daneCode": "25175", "latitude": 4.866508, "longitude": -74.050000}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25178', 'Chipaque', 475, '{"daneCode": "25178", "latitude": 4.442671, "longitude": -74.044876}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25181', 'Choachí', 476, '{"daneCode": "25181", "latitude": 4.527048, "longitude": -73.922894}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25183', 'Chocontá', 477, '{"daneCode": "25183", "latitude": 5.145224, "longitude": -73.683533}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25200', 'Cogua', 478, '{"daneCode": "25200", "latitude": 5.061842, "longitude": -73.978497}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25214', 'Cota', 479, '{"daneCode": "25214", "latitude": 4.812564, "longitude": -74.102569}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25224', 'Cucunubá', 480, '{"daneCode": "25224", "latitude": 5.249795, "longitude": -73.766113}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25245', 'El Colegio', 481, '{"daneCode": "25245", "latitude": 4.577951, "longitude": -74.442261}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25258', 'El Peñón', 482, '{"daneCode": "25258", "latitude": 5.248747, "longitude": -74.290207}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25260', 'El Rosal', 483, '{"daneCode": "25260", "latitude": 4.850589, "longitude": -74.263103}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25269', 'Facatativá', 484, '{"daneCode": "25269", "latitude": 4.813353, "longitude": -74.350085}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25279', 'Fómeque', 485, '{"daneCode": "25279", "latitude": 4.485474, "longitude": -73.892523}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25281', 'Fosca', 486, '{"daneCode": "25281", "latitude": 4.339093, "longitude": -73.939020}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25286', 'Funza', 487, '{"daneCode": "25286", "latitude": 4.710412, "longitude": -74.201528}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25288', 'Fúquene', 488, '{"daneCode": "25288", "latitude": 5.403997, "longitude": -73.795855}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25290', 'Fusagasugá', 489, '{"daneCode": "25290", "latitude": 4.336723, "longitude": -74.375430}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25293', 'Gachalá', 490, '{"daneCode": "25293", "latitude": 4.693579, "longitude": -73.520161}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25295', 'Gachancipá', 491, '{"daneCode": "25295", "latitude": 4.990947, "longitude": -73.873464}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25297', 'Gachetá', 492, '{"daneCode": "25297", "latitude": 4.816411, "longitude": -73.636377}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25299', 'Gama', 493, '{"daneCode": "25299", "latitude": 4.763325, "longitude": -73.611037}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25307', 'Girardot', 494, '{"daneCode": "25307", "latitude": 4.313069, "longitude": -74.798201}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25312', 'Granada', 495, '{"daneCode": "25312", "latitude": 4.519763, "longitude": -74.350766}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25317', 'Guachetá', 496, '{"daneCode": "25317", "latitude": 5.383378, "longitude": -73.686972}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25320', 'Guaduas', 497, '{"daneCode": "25320", "latitude": 5.072076, "longitude": -74.603402}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25322', 'Guasca', 498, '{"daneCode": "25322", "latitude": 4.866719, "longitude": -73.877143}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25324', 'Guataquí', 499, '{"daneCode": "25324", "latitude": 4.517517, "longitude": -74.790058}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25326', 'Guatavita', 500, '{"daneCode": "25326", "latitude": 4.935211, "longitude": -73.832930}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25328', 'Guayabal De Síquima', 501, '{"daneCode": "25328", "latitude": 4.877968, "longitude": -74.467437}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25335', 'Guayabetal', 502, '{"daneCode": "25335", "latitude": 4.215306, "longitude": -73.815107}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25339', 'Gutiérrez', 503, '{"daneCode": "25339", "latitude": 4.254679, "longitude": -74.003042}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25368', 'Jerusalén', 504, '{"daneCode": "25368", "latitude": 4.562273, "longitude": -74.695474}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25372', 'Junín', 505, '{"daneCode": "25372", "latitude": 4.790570, "longitude": -73.662961}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25377', 'La Calera', 506, '{"daneCode": "25377", "latitude": 4.721104, "longitude": -73.968161}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25386', 'La Mesa', 507, '{"daneCode": "25386", "latitude": 4.631028, "longitude": -74.461588}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25394', 'La Palma', 508, '{"daneCode": "25394", "latitude": 5.358816, "longitude": -74.391022}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25398', 'La Peña', 509, '{"daneCode": "25398", "latitude": 5.198945, "longitude": -74.394105}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25402', 'La Vega', 510, '{"daneCode": "25402", "latitude": 4.997768, "longitude": -74.336885}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25407', 'Lenguazaque', 511, '{"daneCode": "25407", "latitude": 5.306131, "longitude": -73.711512}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25426', 'Machetá', 512, '{"daneCode": "25426", "latitude": 5.080070, "longitude": -73.608226}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25430', 'Madrid', 513, '{"daneCode": "25430", "latitude": 4.732791, "longitude": -74.265854}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25436', 'Manta', 514, '{"daneCode": "25436", "latitude": 5.009008, "longitude": -73.540444}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25438', 'Medina', 515, '{"daneCode": "25438", "latitude": 4.506298, "longitude": -73.348449}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25473', 'Mosquera', 516, '{"daneCode": "25473", "latitude": 4.706530, "longitude": -74.221154}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25483', 'Nariño', 517, '{"daneCode": "25483", "latitude": 4.399837, "longitude": -74.824732}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25486', 'Nemocón', 518, '{"daneCode": "25486", "latitude": 5.068705, "longitude": -73.877888}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25488', 'Nilo', 519, '{"daneCode": "25488", "latitude": 4.305838, "longitude": -74.620009}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25489', 'Nimaima', 520, '{"daneCode": "25489", "latitude": 5.125992, "longitude": -74.386040}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25491', 'Nocaima', 521, '{"daneCode": "25491", "latitude": 5.069466, "longitude": -74.379093}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25506', 'Venecia', 522, '{"daneCode": "25506", "latitude": 4.089056, "longitude": -74.478301}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25513', 'Pacho', 523, '{"daneCode": "25513", "latitude": 5.136907, "longitude": -74.156132}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25518', 'Paime', 524, '{"daneCode": "25518", "latitude": 5.370487, "longitude": -74.152213}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25524', 'Pandi', 525, '{"daneCode": "25524", "latitude": 4.190393, "longitude": -74.486641}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25530', 'Paratebueno', 526, '{"daneCode": "25530", "latitude": 4.374832, "longitude": -73.212825}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25535', 'Pasca', 527, '{"daneCode": "25535", "latitude": 4.308979, "longitude": -74.302276}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25572', 'Puerto Salgar', 528, '{"daneCode": "25572", "latitude": 5.465413, "longitude": -74.653695}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25580', 'Pulí', 529, '{"daneCode": "25580", "latitude": 4.682022, "longitude": -74.714380}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25592', 'Quebradanegra', 530, '{"daneCode": "25592", "latitude": 5.118076, "longitude": -74.480140}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25594', 'Quetame', 531, '{"daneCode": "25594", "latitude": 4.329884, "longitude": -73.863214}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25596', 'Quipile', 532, '{"daneCode": "25596", "latitude": 4.744810, "longitude": -74.533705}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25599', 'Apulo', 533, '{"daneCode": "25599", "latitude": 4.520304, "longitude": -74.593926}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25612', 'Ricaurte', 534, '{"daneCode": "25612", "latitude": 4.282113, "longitude": -74.772861}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25645', 'San Antonio Del Tequendama', 535, '{"daneCode": "25645", "latitude": 4.616138, "longitude": -74.351443}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25649', 'San Bernardo', 536, '{"daneCode": "25649", "latitude": 4.179433, "longitude": -74.422960}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25653', 'San Cayetano', 537, '{"daneCode": "25653", "latitude": 5.332938, "longitude": -74.024754}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25658', 'San Francisco', 538, '{"daneCode": "25658", "latitude": 4.972917, "longitude": -74.289672}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25662', 'San Juan De Rioseco', 539, '{"daneCode": "25662", "latitude": 4.847575, "longitude": -74.621919}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25718', 'Sasaima', 540, '{"daneCode": "25718", "latitude": 4.962167, "longitude": -74.432628}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25736', 'Sesquilé', 541, '{"daneCode": "25736", "latitude": 5.044760, "longitude": -73.796099}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25740', 'Sibaté', 542, '{"daneCode": "25740", "latitude": 4.492625, "longitude": -74.257874}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25743', 'Silvania', 543, '{"daneCode": "25743", "latitude": 4.381981, "longitude": -74.405534}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25745', 'Simijaca', 544, '{"daneCode": "25745", "latitude": 5.505231, "longitude": -73.850703}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25754', 'Soacha', 545, '{"daneCode": "25754", "latitude": 4.579268, "longitude": -74.215463}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25758', 'Sopó', 546, '{"daneCode": "25758", "latitude": 4.915395, "longitude": -73.943328}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25769', 'Subachoque', 547, '{"daneCode": "25769", "latitude": 4.929118, "longitude": -74.172773}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25772', 'Suesca', 548, '{"daneCode": "25772", "latitude": 5.103495, "longitude": -73.798227}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25777', 'Supatá', 549, '{"daneCode": "25777", "latitude": 5.061620, "longitude": -74.235403}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25779', 'Susa', 550, '{"daneCode": "25779", "latitude": 5.455291, "longitude": -73.813938}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25781', 'Sutatausa', 551, '{"daneCode": "25781", "latitude": 5.247482, "longitude": -73.853159}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25785', 'Tabio', 552, '{"daneCode": "25785", "latitude": 4.916832, "longitude": -74.096461}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25793', 'Tausa', 553, '{"daneCode": "25793", "latitude": 5.196333, "longitude": -73.887813}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25797', 'Tena', 554, '{"daneCode": "25797", "latitude": 4.655286, "longitude": -74.389193}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25799', 'Tenjo', 555, '{"daneCode": "25799", "latitude": 4.872014, "longitude": -74.143724}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25805', 'Tibacuy', 556, '{"daneCode": "25805", "latitude": 4.348605, "longitude": -74.452662}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25807', 'Tibirita', 557, '{"daneCode": "25807", "latitude": 5.052278, "longitude": -73.504514}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25815', 'Tocaima', 558, '{"daneCode": "25815", "latitude": 4.459279, "longitude": -74.636296}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25817', 'Tocancipá', 559, '{"daneCode": "25817", "latitude": 4.964641, "longitude": -73.912070}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25823', 'Topaipí', 560, '{"daneCode": "25823", "latitude": 5.336224, "longitude": -74.300626}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25839', 'Ubalá', 561, '{"daneCode": "25839", "latitude": 4.747620, "longitude": -73.531489}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25841', 'Ubaque', 562, '{"daneCode": "25841", "latitude": 4.483788, "longitude": -73.933477}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25843', 'Villa De San Diego De Ubaté', 563, '{"daneCode": "25843", "latitude": 5.307463, "longitude": -73.814367}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25845', 'Une', 564, '{"daneCode": "25845", "latitude": 4.402450, "longitude": -74.025183}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25851', 'Útica', 565, '{"daneCode": "25851", "latitude": 5.190550, "longitude": -74.483154}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25862', 'Vergara', 566, '{"daneCode": "25862", "latitude": 5.117258, "longitude": -74.346163}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25867', 'Vianí', 567, '{"daneCode": "25867", "latitude": 4.875208, "longitude": -74.561320}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25871', 'Villagómez', 568, '{"daneCode": "25871", "latitude": 5.273024, "longitude": -74.195145}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25873', 'Villapinzón', 569, '{"daneCode": "25873", "latitude": 5.216393, "longitude": -73.595704}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25875', 'Villeta', 570, '{"daneCode": "25875", "latitude": 5.012754, "longitude": -74.469686}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25878', 'Viotá', 571, '{"daneCode": "25878", "latitude": 4.439350, "longitude": -74.523131}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25885', 'Yacopí', 572, '{"daneCode": "25885", "latitude": 5.459272, "longitude": -74.338060}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25898', 'Zipacón', 573, '{"daneCode": "25898", "latitude": 4.759932, "longitude": -74.379566}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '25899', 'Zipaquirá', 574, '{"daneCode": "25899", "latitude": 5.025477, "longitude": -73.994444}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '25'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27001', 'Quibdó', 575, '{"daneCode": "27001", "latitude": 5.682166, "longitude": -76.638144}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27006', 'Acandí', 576, '{"daneCode": "27006", "latitude": 8.512178, "longitude": -77.279951}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27025', 'Alto Baudó', 577, '{"daneCode": "27025", "latitude": 5.516221, "longitude": -76.974373}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27050', 'Atrato', 578, '{"daneCode": "27050", "latitude": 5.531419, "longitude": -76.635674}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27073', 'Bagadó', 579, '{"daneCode": "27073", "latitude": 5.409681, "longitude": -76.416063}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27075', 'Bahía Solano', 580, '{"daneCode": "27075", "latitude": 6.222807, "longitude": -77.401359}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27077', 'Bajo Baudó', 581, '{"daneCode": "27077", "latitude": 4.954576, "longitude": -77.365717}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27099', 'Bojayá', 582, '{"daneCode": "27099", "latitude": 6.559708, "longitude": -76.886773}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27135', 'El Cantón Del San Pablo', 583, '{"daneCode": "27135", "latitude": 5.335321, "longitude": -76.726844}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27150', 'Carmen Del Darién', 584, '{"daneCode": "27150", "latitude": 7.158294, "longitude": -76.970798}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27160', 'Cértegui', 585, '{"daneCode": "27160", "latitude": 5.371373, "longitude": -76.607619}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27205', 'Condoto', 586, '{"daneCode": "27205", "latitude": 5.091003, "longitude": -76.650683}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27245', 'El Carmen De Atrato', 587, '{"daneCode": "27245", "latitude": 5.899789, "longitude": -76.142112}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27250', 'El Litoral Del San Juan', 588, '{"daneCode": "27250", "latitude": 4.259564, "longitude": -77.363702}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27361', 'Istmina', 589, '{"daneCode": "27361", "latitude": 5.153946, "longitude": -76.685180}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27372', 'Juradó', 590, '{"daneCode": "27372", "latitude": 7.103619, "longitude": -77.762751}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27413', 'Lloró', 591, '{"daneCode": "27413", "latitude": 5.497890, "longitude": -76.545147}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27425', 'Medio Atrato', 592, '{"daneCode": "27425", "latitude": 5.994935, "longitude": -76.783042}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27430', 'Medio Baudó', 593, '{"daneCode": "27430", "latitude": 5.192471, "longitude": -76.950891}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27450', 'Medio San Juan', 594, '{"daneCode": "27450", "latitude": 5.098291, "longitude": -76.694409}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27491', 'Nóvita', 595, '{"daneCode": "27491", "latitude": 4.956063, "longitude": -76.609467}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27493', 'Nuevo Belén De Bajirá', 596, '{"daneCode": "27493", "latitude": 7.371900, "longitude": -76.717270}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27495', 'Nuquí', 597, '{"daneCode": "27495", "latitude": 5.709812, "longitude": -77.265507}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27580', 'Río Iró', 598, '{"daneCode": "27580", "latitude": 5.186300, "longitude": -76.472925}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27600', 'Río Quito', 599, '{"daneCode": "27600", "latitude": 5.483667, "longitude": -76.740684}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27615', 'Riosucio', 600, '{"daneCode": "27615", "latitude": 7.436704, "longitude": -77.113156}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27660', 'San José Del Palmar', 601, '{"daneCode": "27660", "latitude": 4.896954, "longitude": -76.234227}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27745', 'Sipí', 602, '{"daneCode": "27745", "latitude": 4.652620, "longitude": -76.643453}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27787', 'Tadó', 603, '{"daneCode": "27787", "latitude": 5.264873, "longitude": -76.558571}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27800', 'Unguía', 604, '{"daneCode": "27800", "latitude": 8.044060, "longitude": -77.092538}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '27810', 'Unión Panamericana', 605, '{"daneCode": "27810", "latitude": 5.281108, "longitude": -76.630143}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '27'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41001', 'Neiva', 606, '{"daneCode": "41001", "latitude": 2.935432, "longitude": -75.277327}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41006', 'Acevedo', 607, '{"daneCode": "41006", "latitude": 1.805173, "longitude": -75.888706}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41013', 'Agrado', 608, '{"daneCode": "41013", "latitude": 2.259870, "longitude": -75.772022}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41016', 'Aipe', 609, '{"daneCode": "41016", "latitude": 3.223996, "longitude": -75.239017}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41020', 'Algeciras', 610, '{"daneCode": "41020", "latitude": 2.521674, "longitude": -75.315389}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41026', 'Altamira', 611, '{"daneCode": "41026", "latitude": 2.063841, "longitude": -75.788471}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41078', 'Baraya', 612, '{"daneCode": "41078", "latitude": 3.152204, "longitude": -75.054843}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41132', 'Campoalegre', 613, '{"daneCode": "41132", "latitude": 2.686767, "longitude": -75.325748}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41206', 'Colombia', 614, '{"daneCode": "41206", "latitude": 3.376745, "longitude": -74.802815}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41244', 'Elías', 615, '{"daneCode": "41244", "latitude": 2.012854, "longitude": -75.938301}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41298', 'Garzón', 616, '{"daneCode": "41298", "latitude": 2.196493, "longitude": -75.627057}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41306', 'Gigante', 617, '{"daneCode": "41306", "latitude": 2.384031, "longitude": -75.547681}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41319', 'Guadalupe', 618, '{"daneCode": "41319", "latitude": 2.024260, "longitude": -75.757185}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41349', 'Hobo', 619, '{"daneCode": "41349", "latitude": 2.580812, "longitude": -75.447697}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41357', 'Íquira', 620, '{"daneCode": "41357", "latitude": 2.649359, "longitude": -75.634497}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41359', 'Isnos', 621, '{"daneCode": "41359", "latitude": 1.929467, "longitude": -76.217637}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41378', 'La Argentina', 622, '{"daneCode": "41378", "latitude": 2.198496, "longitude": -75.979763}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41396', 'La Plata', 623, '{"daneCode": "41396", "latitude": 2.389263, "longitude": -75.891254}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41483', 'Nátaga', 624, '{"daneCode": "41483", "latitude": 2.545100, "longitude": -75.808756}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41503', 'Oporapa', 625, '{"daneCode": "41503", "latitude": 2.025088, "longitude": -75.995165}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41518', 'Paicol', 626, '{"daneCode": "41518", "latitude": 2.449651, "longitude": -75.773158}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41524', 'Palermo', 627, '{"daneCode": "41524", "latitude": 2.889649, "longitude": -75.435296}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41530', 'Palestina', 628, '{"daneCode": "41530", "latitude": 1.723725, "longitude": -76.133251}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41548', 'Pital', 629, '{"daneCode": "41548", "latitude": 2.266618, "longitude": -75.804544}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41551', 'Pitalito', 630, '{"daneCode": "41551", "latitude": 1.852631, "longitude": -76.049441}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41615', 'Rivera', 631, '{"daneCode": "41615", "latitude": 2.777586, "longitude": -75.258753}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41660', 'Saladoblanco', 632, '{"daneCode": "41660", "latitude": 1.993400, "longitude": -76.044747}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41668', 'San Agustín', 633, '{"daneCode": "41668", "latitude": 1.881081, "longitude": -76.270360}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41676', 'Santa María', 634, '{"daneCode": "41676", "latitude": 2.939603, "longitude": -75.586223}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41770', 'Suaza', 635, '{"daneCode": "41770", "latitude": 1.976051, "longitude": -75.795250}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41791', 'Tarqui', 636, '{"daneCode": "41791", "latitude": 2.111325, "longitude": -75.823976}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41797', 'Tesalia', 637, '{"daneCode": "41797", "latitude": 2.486364, "longitude": -75.730271}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41799', 'Tello', 638, '{"daneCode": "41799", "latitude": 3.067538, "longitude": -75.138773}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41801', 'Teruel', 639, '{"daneCode": "41801", "latitude": 2.740968, "longitude": -75.567034}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41807', 'Timaná', 640, '{"daneCode": "41807", "latitude": 1.974539, "longitude": -75.932167}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41872', 'Villavieja', 641, '{"daneCode": "41872", "latitude": 3.218822, "longitude": -75.217174}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '41885', 'Yaguará', 642, '{"daneCode": "41885", "latitude": 2.664694, "longitude": -75.518023}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '41'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44001', 'Riohacha', 643, '{"daneCode": "44001", "latitude": 11.528588, "longitude": -72.911795}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44035', 'Albania', 644, '{"daneCode": "44035", "latitude": 11.151628, "longitude": -72.612320}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44078', 'Barrancas', 645, '{"daneCode": "44078", "latitude": 10.958669, "longitude": -72.793639}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44090', 'Dibulla', 646, '{"daneCode": "44090", "latitude": 11.271550, "longitude": -73.307598}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44098', 'Distracción', 647, '{"daneCode": "44098", "latitude": 10.898414, "longitude": -72.887405}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44110', 'El Molino', 648, '{"daneCode": "44110", "latitude": 10.653505, "longitude": -72.926730}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44279', 'Fonseca', 649, '{"daneCode": "44279", "latitude": 10.886734, "longitude": -72.846319}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44378', 'Hatonuevo', 650, '{"daneCode": "44378", "latitude": 11.068864, "longitude": -72.759040}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44420', 'La Jagua Del Pilar', 651, '{"daneCode": "44420", "latitude": 10.511862, "longitude": -73.072638}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44430', 'Maicao', 652, '{"daneCode": "44430", "latitude": 11.378535, "longitude": -72.242738}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44560', 'Manaure', 653, '{"daneCode": "44560", "latitude": 11.773767, "longitude": -72.438739}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44650', 'San Juan Del Cesar', 654, '{"daneCode": "44650", "latitude": 10.769546, "longitude": -73.000629}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44847', 'Uribia', 655, '{"daneCode": "44847", "latitude": 11.711904, "longitude": -72.265906}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44855', 'Urumita', 656, '{"daneCode": "44855", "latitude": 10.560169, "longitude": -73.012507}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '44874', 'Villanueva', 657, '{"daneCode": "44874", "latitude": 10.608774, "longitude": -72.977583}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '44'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47001', 'Santa Marta', 658, '{"daneCode": "47001", "latitude": 11.204679, "longitude": -74.199829}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47030', 'Algarrobo', 659, '{"daneCode": "47030", "latitude": 10.188059, "longitude": -74.061132}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47053', 'Aracataca', 660, '{"daneCode": "47053", "latitude": 10.589791, "longitude": -74.186702}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47058', 'Ariguaní', 661, '{"daneCode": "47058", "latitude": 9.847047, "longitude": -74.236515}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47161', 'Cerro De San Antonio', 662, '{"daneCode": "47161", "latitude": 10.325531, "longitude": -74.868474}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47170', 'Chivolo', 663, '{"daneCode": "47170", "latitude": 10.026631, "longitude": -74.622242}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47189', 'Ciénaga', 664, '{"daneCode": "47189", "latitude": 11.006654, "longitude": -74.241286}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47205', 'Concordia', 665, '{"daneCode": "47205", "latitude": 10.257314, "longitude": -74.833030}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47245', 'El Banco', 666, '{"daneCode": "47245", "latitude": 9.008503, "longitude": -73.974370}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47258', 'El Piñón', 667, '{"daneCode": "47258", "latitude": 10.402781, "longitude": -74.823094}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47268', 'El Retén', 668, '{"daneCode": "47268", "latitude": 10.610488, "longitude": -74.268444}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47288', 'Fundación', 669, '{"daneCode": "47288", "latitude": 10.514146, "longitude": -74.191453}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47318', 'Guamal', 670, '{"daneCode": "47318", "latitude": 9.144354, "longitude": -74.223689}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47460', 'Nueva Granada', 671, '{"daneCode": "47460", "latitude": 9.801860, "longitude": -74.391841}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47541', 'Pedraza', 672, '{"daneCode": "47541", "latitude": 10.188250, "longitude": -74.915400}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47545', 'Pijiño Del Carmen', 673, '{"daneCode": "47545", "latitude": 9.331922, "longitude": -74.459034}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47551', 'Pivijay', 674, '{"daneCode": "47551", "latitude": 10.460707, "longitude": -74.613312}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47555', 'Plato', 675, '{"daneCode": "47555", "latitude": 9.796713, "longitude": -74.784549}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47570', 'Puebloviejo', 676, '{"daneCode": "47570", "latitude": 10.994766, "longitude": -74.282530}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47605', 'Remolino', 677, '{"daneCode": "47605", "latitude": 10.701952, "longitude": -74.716172}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47660', 'Sabanas De San Ángel', 678, '{"daneCode": "47660", "latitude": 10.032536, "longitude": -74.213946}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47675', 'Salamina', 679, '{"daneCode": "47675", "latitude": 10.491229, "longitude": -74.794189}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47692', 'San Sebastián De Buenavista', 680, '{"daneCode": "47692", "latitude": 9.241656, "longitude": -74.351498}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47703', 'San Zenón', 681, '{"daneCode": "47703", "latitude": 9.245061, "longitude": -74.498992}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47707', 'Santa Ana', 682, '{"daneCode": "47707", "latitude": 9.324294, "longitude": -74.566845}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47720', 'Santa Bárbara De Pinto', 683, '{"daneCode": "47720", "latitude": 9.432263, "longitude": -74.704667}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47745', 'Sitionuevo', 684, '{"daneCode": "47745", "latitude": 10.775285, "longitude": -74.720021}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47798', 'Tenerife', 685, '{"daneCode": "47798", "latitude": 9.898273, "longitude": -74.859783}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47960', 'Zapayán', 686, '{"daneCode": "47960", "latitude": 10.168297, "longitude": -74.716878}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '47980', 'Zona Bananera', 687, '{"daneCode": "47980", "latitude": 10.763024, "longitude": -74.140091}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '47'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50001', 'Villavicencio', 688, '{"daneCode": "50001", "latitude": 4.126369, "longitude": -73.622601}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50006', 'Acacías', 689, '{"daneCode": "50006", "latitude": 3.990413, "longitude": -73.766034}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50110', 'Barranca De Upía', 690, '{"daneCode": "50110", "latitude": 4.566225, "longitude": -72.961083}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50124', 'Cabuyaro', 691, '{"daneCode": "50124", "latitude": 4.286705, "longitude": -72.791768}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50150', 'Castilla La Nueva', 692, '{"daneCode": "50150", "latitude": 3.830005, "longitude": -73.687302}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50223', 'Cubarral', 693, '{"daneCode": "50223", "latitude": 3.793653, "longitude": -73.837999}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50226', 'Cumaral', 694, '{"daneCode": "50226", "latitude": 4.270042, "longitude": -73.487052}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50245', 'El Calvario', 695, '{"daneCode": "50245", "latitude": 4.352665, "longitude": -73.713325}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50251', 'El Castillo', 696, '{"daneCode": "50251", "latitude": 3.563907, "longitude": -73.794225}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50270', 'El Dorado', 697, '{"daneCode": "50270", "latitude": 3.739984, "longitude": -73.835264}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50287', 'Fuente De Oro', 698, '{"daneCode": "50287", "latitude": 3.462875, "longitude": -73.618121}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50313', 'Granada', 699, '{"daneCode": "50313", "latitude": 3.547147, "longitude": -73.705815}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50318', 'Guamal', 700, '{"daneCode": "50318", "latitude": 3.879657, "longitude": -73.768815}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50325', 'Mapiripán', 701, '{"daneCode": "50325", "latitude": 2.896617, "longitude": -72.135509}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50330', 'Mesetas', 702, '{"daneCode": "50330", "latitude": 3.382732, "longitude": -74.044328}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50350', 'La Macarena', 703, '{"daneCode": "50350", "latitude": 2.177143, "longitude": -73.786610}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50370', 'Uribe', 704, '{"daneCode": "50370", "latitude": 3.239634, "longitude": -74.351508}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50400', 'Lejanías', 705, '{"daneCode": "50400", "latitude": 3.525115, "longitude": -74.023514}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50450', 'Puerto Concordia', 706, '{"daneCode": "50450", "latitude": 2.624006, "longitude": -72.760209}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50568', 'Puerto Gaitán', 707, '{"daneCode": "50568", "latitude": 4.314905, "longitude": -72.087649}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50573', 'Puerto López', 708, '{"daneCode": "50573", "latitude": 4.093490, "longitude": -72.957324}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50577', 'Puerto Lleras', 709, '{"daneCode": "50577", "latitude": 3.272117, "longitude": -73.373850}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50590', 'Puerto Rico', 710, '{"daneCode": "50590", "latitude": 2.939621, "longitude": -73.206314}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50606', 'Restrepo', 711, '{"daneCode": "50606", "latitude": 4.259556, "longitude": -73.565408}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50680', 'San Carlos De Guaroa', 712, '{"daneCode": "50680", "latitude": 3.710650, "longitude": -73.242253}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50683', 'San Juan De Arama', 713, '{"daneCode": "50683", "latitude": 3.373728, "longitude": -73.875832}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50686', 'San Juanito', 714, '{"daneCode": "50686", "latitude": 4.458181, "longitude": -73.676699}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50689', 'San Martín', 715, '{"daneCode": "50689", "latitude": 3.701899, "longitude": -73.695812}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '50711', 'Vistahermosa', 716, '{"daneCode": "50711", "latitude": 3.125579, "longitude": -73.750966}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '50'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52001', 'Pasto', 717, '{"daneCode": "52001", "latitude": 1.212352, "longitude": -77.278795}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52019', 'Albán', 718, '{"daneCode": "52019", "latitude": 1.474978, "longitude": -77.080712}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52022', 'Aldana', 719, '{"daneCode": "52022", "latitude": 0.882381, "longitude": -77.700564}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52036', 'Ancuya', 720, '{"daneCode": "52036", "latitude": 1.263276, "longitude": -77.514512}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52051', 'Arboleda', 721, '{"daneCode": "52051", "latitude": 1.503418, "longitude": -77.135467}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52079', 'Barbacoas', 722, '{"daneCode": "52079", "latitude": 1.671733, "longitude": -78.137650}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52083', 'Belén', 723, '{"daneCode": "52083", "latitude": 1.595681, "longitude": -77.015619}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52110', 'Buesaco', 724, '{"daneCode": "52110", "latitude": 1.381453, "longitude": -77.156463}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52203', 'Colón', 725, '{"daneCode": "52203", "latitude": 1.643878, "longitude": -77.019777}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52207', 'Consacá', 726, '{"daneCode": "52207", "latitude": 1.207854, "longitude": -77.466136}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52210', 'Contadero', 727, '{"daneCode": "52210", "latitude": 0.910458, "longitude": -77.549409}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52215', 'Córdoba', 728, '{"daneCode": "52215", "latitude": 0.854564, "longitude": -77.517897}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52224', 'Cuaspud Carlosama', 729, '{"daneCode": "52224", "latitude": 0.862978, "longitude": -77.728947}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52227', 'Cumbal', 730, '{"daneCode": "52227", "latitude": 0.906367, "longitude": -77.792505}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52233', 'Cumbitara', 731, '{"daneCode": "52233", "latitude": 1.647163, "longitude": -77.578616}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52240', 'Chachagüí', 732, '{"daneCode": "52240", "latitude": 1.360545, "longitude": -77.281869}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52250', 'El Charco', 733, '{"daneCode": "52250", "latitude": 2.479688, "longitude": -78.110217}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52254', 'El Peñol', 734, '{"daneCode": "52254", "latitude": 1.453567, "longitude": -77.438522}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52256', 'El Rosario', 735, '{"daneCode": "52256", "latitude": 1.745309, "longitude": -77.334170}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52258', 'El Tablón De Gómez', 736, '{"daneCode": "52258", "latitude": 1.427277, "longitude": -77.097101}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52260', 'El Tambo', 737, '{"daneCode": "52260", "latitude": 1.407913, "longitude": -77.390772}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52287', 'Funes', 738, '{"daneCode": "52287", "latitude": 1.001159, "longitude": -77.448913}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52317', 'Guachucal', 739, '{"daneCode": "52317", "latitude": 0.959744, "longitude": -77.731589}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52320', 'Guaitarilla', 740, '{"daneCode": "52320", "latitude": 1.129574, "longitude": -77.549824}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52323', 'Gualmatán', 741, '{"daneCode": "52323", "latitude": 0.919652, "longitude": -77.568701}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52352', 'Iles', 742, '{"daneCode": "52352", "latitude": 0.969520, "longitude": -77.521227}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52354', 'Imués', 743, '{"daneCode": "52354", "latitude": 1.055060, "longitude": -77.496339}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52356', 'Ipiales', 744, '{"daneCode": "52356", "latitude": 0.827732, "longitude": -77.646367}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52378', 'La Cruz', 745, '{"daneCode": "52378", "latitude": 1.601318, "longitude": -76.970504}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52381', 'La Florida', 746, '{"daneCode": "52381", "latitude": 1.297530, "longitude": -77.402882}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52385', 'La Llanada', 747, '{"daneCode": "52385", "latitude": 1.472892, "longitude": -77.580910}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52390', 'La Tola', 748, '{"daneCode": "52390", "latitude": 2.398999, "longitude": -78.189725}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52399', 'La Unión', 749, '{"daneCode": "52399", "latitude": 1.600219, "longitude": -77.131316}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52405', 'Leiva', 750, '{"daneCode": "52405", "latitude": 1.934453, "longitude": -77.306135}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52411', 'Linares', 751, '{"daneCode": "52411", "latitude": 1.350814, "longitude": -77.523953}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52418', 'Los Andes', 752, '{"daneCode": "52418", "latitude": 1.494587, "longitude": -77.521303}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52427', 'Magüí', 753, '{"daneCode": "52427", "latitude": 1.765633, "longitude": -78.182924}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52435', 'Mallama', 754, '{"daneCode": "52435", "latitude": 1.141037, "longitude": -77.864549}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52473', 'Mosquera', 755, '{"daneCode": "52473", "latitude": 2.507139, "longitude": -78.452992}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52480', 'Nariño', 756, '{"daneCode": "52480", "latitude": 1.288979, "longitude": -77.357972}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52490', 'Olaya Herrera', 757, '{"daneCode": "52490", "latitude": 2.347457, "longitude": -78.325814}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52506', 'Ospina', 758, '{"daneCode": "52506", "latitude": 1.058433, "longitude": -77.566082}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52520', 'Francisco Pizarro', 759, '{"daneCode": "52520", "latitude": 2.040629, "longitude": -78.658361}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52540', 'Policarpa', 760, '{"daneCode": "52540", "latitude": 1.627196, "longitude": -77.458686}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52560', 'Potosí', 761, '{"daneCode": "52560", "latitude": 0.806639, "longitude": -77.573003}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52565', 'Providencia', 762, '{"daneCode": "52565", "latitude": 1.237814, "longitude": -77.596794}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52573', 'Puerres', 763, '{"daneCode": "52573", "latitude": 0.885125, "longitude": -77.504211}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52585', 'Pupiales', 764, '{"daneCode": "52585", "latitude": 0.870442, "longitude": -77.636042}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52612', 'Ricaurte', 765, '{"daneCode": "52612", "latitude": 1.212492, "longitude": -77.995153}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52621', 'Roberto Payán', 766, '{"daneCode": "52621", "latitude": 1.697492, "longitude": -78.245716}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52678', 'Samaniego', 767, '{"daneCode": "52678", "latitude": 1.335438, "longitude": -77.594341}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52683', 'Sandoná', 768, '{"daneCode": "52683", "latitude": 1.283438, "longitude": -77.473130}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52685', 'San Bernardo', 769, '{"daneCode": "52685", "latitude": 1.513762, "longitude": -77.047500}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52687', 'San Lorenzo', 770, '{"daneCode": "52687", "latitude": 1.503362, "longitude": -77.215420}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52693', 'San Pablo', 771, '{"daneCode": "52693", "latitude": 1.669429, "longitude": -77.013984}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52694', 'San Pedro De Cartago', 772, '{"daneCode": "52694", "latitude": 1.551572, "longitude": -77.119410}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52696', 'Santa Bárbara', 773, '{"daneCode": "52696", "latitude": 2.449653, "longitude": -77.979916}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52699', 'Santacruz', 774, '{"daneCode": "52699", "latitude": 1.222589, "longitude": -77.677035}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52720', 'Sapuyes', 775, '{"daneCode": "52720", "latitude": 1.037536, "longitude": -77.620280}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52786', 'Taminango', 776, '{"daneCode": "52786", "latitude": 1.570358, "longitude": -77.280800}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52788', 'Tangua', 777, '{"daneCode": "52788", "latitude": 1.094820, "longitude": -77.393735}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52835', 'San Andrés De Tumaco', 778, '{"daneCode": "52835", "latitude": 1.807399, "longitude": -78.764073}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52838', 'Túquerres', 779, '{"daneCode": "52838", "latitude": 1.085044, "longitude": -77.616720}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '52885', 'Yacuanquer', 780, '{"daneCode": "52885", "latitude": 1.115937, "longitude": -77.400169}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '52'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54001', 'San José De Cúcuta', 781, '{"daneCode": "54001", "latitude": 7.905725, "longitude": -72.508178}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54003', 'Ábrego', 782, '{"daneCode": "54003", "latitude": 8.081616, "longitude": -73.221722}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54051', 'Arboledas', 783, '{"daneCode": "54051", "latitude": 7.642985, "longitude": -72.798952}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54099', 'Bochalema', 784, '{"daneCode": "54099", "latitude": 7.612192, "longitude": -72.647010}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54109', 'Bucarasica', 785, '{"daneCode": "54109", "latitude": 8.041299, "longitude": -72.868231}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54125', 'Cácota', 786, '{"daneCode": "54125", "latitude": 7.268705, "longitude": -72.642059}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54128', 'Cáchira', 787, '{"daneCode": "54128", "latitude": 7.741248, "longitude": -73.048983}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54172', 'Chinácota', 788, '{"daneCode": "54172", "latitude": 7.603112, "longitude": -72.601162}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54174', 'Chitagá', 789, '{"daneCode": "54174", "latitude": 7.138187, "longitude": -72.665468}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54206', 'Convención', 790, '{"daneCode": "54206", "latitude": 8.470374, "longitude": -73.337200}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54223', 'Cucutilla', 791, '{"daneCode": "54223", "latitude": 7.539633, "longitude": -72.772816}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54239', 'Durania', 792, '{"daneCode": "54239", "latitude": 7.714804, "longitude": -72.658491}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54245', 'El Carmen', 793, '{"daneCode": "54245", "latitude": 8.510579, "longitude": -73.446687}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54250', 'El Tarra', 794, '{"daneCode": "54250", "latitude": 8.574281, "longitude": -73.096140}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54261', 'El Zulia', 795, '{"daneCode": "54261", "latitude": 7.938572, "longitude": -72.604717}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54313', 'Gramalote', 796, '{"daneCode": "54313", "latitude": 7.916946, "longitude": -72.787233}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54344', 'Hacarí', 797, '{"daneCode": "54344", "latitude": 8.321506, "longitude": -73.145997}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54347', 'Herrán', 798, '{"daneCode": "54347", "latitude": 7.506541, "longitude": -72.483519}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54377', 'Labateca', 799, '{"daneCode": "54377", "latitude": 7.298414, "longitude": -72.495983}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54385', 'La Esperanza', 800, '{"daneCode": "54385", "latitude": 7.639839, "longitude": -73.328126}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54398', 'La Playa', 801, '{"daneCode": "54398", "latitude": 8.211240, "longitude": -73.239986}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54405', 'Los Patios', 802, '{"daneCode": "54405", "latitude": 7.833186, "longitude": -72.505612}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54418', 'Lourdes', 803, '{"daneCode": "54418", "latitude": 7.945631, "longitude": -72.832376}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54480', 'Mutiscua', 804, '{"daneCode": "54480", "latitude": 7.300469, "longitude": -72.747169}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54498', 'Ocaña', 805, '{"daneCode": "54498", "latitude": 8.248574, "longitude": -73.356070}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54518', 'Pamplona', 806, '{"daneCode": "54518", "latitude": 7.372802, "longitude": -72.647714}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54520', 'Pamplonita', 807, '{"daneCode": "54520", "latitude": 7.436745, "longitude": -72.639111}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54553', 'Puerto Santander', 808, '{"daneCode": "54553", "latitude": 8.359993, "longitude": -72.411363}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54599', 'Ragonvalia', 809, '{"daneCode": "54599", "latitude": 7.577861, "longitude": -72.476708}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54660', 'Salazar', 810, '{"daneCode": "54660", "latitude": 7.773683, "longitude": -72.813064}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54670', 'San Calixto', 811, '{"daneCode": "54670", "latitude": 8.402140, "longitude": -73.208622}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54673', 'San Cayetano', 812, '{"daneCode": "54673", "latitude": 7.875695, "longitude": -72.625459}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54680', 'Santiago', 813, '{"daneCode": "54680", "latitude": 7.865856, "longitude": -72.716203}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54720', 'Sardinata', 814, '{"daneCode": "54720", "latitude": 8.082105, "longitude": -72.800577}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54743', 'Silos', 815, '{"daneCode": "54743", "latitude": 7.204736, "longitude": -72.757128}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54800', 'Teorama', 816, '{"daneCode": "54800", "latitude": 8.438134, "longitude": -73.287070}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54810', 'Tibú', 817, '{"daneCode": "54810", "latitude": 8.639891, "longitude": -72.734496}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54820', 'Toledo', 818, '{"daneCode": "54820", "latitude": 7.307692, "longitude": -72.481915}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54871', 'Villa Caro', 819, '{"daneCode": "54871", "latitude": 7.914244, "longitude": -72.973601}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '54874', 'Villa Del Rosario', 820, '{"daneCode": "54874", "latitude": 7.847672, "longitude": -72.469758}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '54'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63001', 'Armenia', 821, '{"daneCode": "63001", "latitude": 4.535980, "longitude": -75.680786}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63111', 'Buenavista', 822, '{"daneCode": "63111", "latitude": 4.360029, "longitude": -75.739572}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63130', 'Calarcá', 823, '{"daneCode": "63130", "latitude": 4.520982, "longitude": -75.646085}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63190', 'Circasia', 824, '{"daneCode": "63190", "latitude": 4.617759, "longitude": -75.636533}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63212', 'Córdoba', 825, '{"daneCode": "63212", "latitude": 4.392485, "longitude": -75.687866}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63272', 'Filandia', 826, '{"daneCode": "63272", "latitude": 4.674338, "longitude": -75.658387}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63302', 'Génova', 827, '{"daneCode": "63302", "latitude": 4.206641, "longitude": -75.790402}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63401', 'La Tebaida', 828, '{"daneCode": "63401", "latitude": 4.453755, "longitude": -75.786887}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63470', 'Montenegro', 829, '{"daneCode": "63470", "latitude": 4.565057, "longitude": -75.749827}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63548', 'Pijao', 830, '{"daneCode": "63548", "latitude": 4.335036, "longitude": -75.703329}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63594', 'Quimbaya', 831, '{"daneCode": "63594", "latitude": 4.624387, "longitude": -75.765074}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '63690', 'Salento', 832, '{"daneCode": "63690", "latitude": 4.637157, "longitude": -75.570844}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '63'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66001', 'Pereira', 833, '{"daneCode": "66001", "latitude": 4.804985, "longitude": -75.719711}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66045', 'Apía', 834, '{"daneCode": "66045", "latitude": 5.106526, "longitude": -75.942356}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66075', 'Balboa', 835, '{"daneCode": "66075", "latitude": 4.949096, "longitude": -75.958663}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66088', 'Belén De Umbría', 836, '{"daneCode": "66088", "latitude": 5.200793, "longitude": -75.868334}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66170', 'Dosquebradas', 837, '{"daneCode": "66170", "latitude": 4.833131, "longitude": -75.675371}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66318', 'Guática', 838, '{"daneCode": "66318", "latitude": 5.315367, "longitude": -75.799005}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66383', 'La Celia', 839, '{"daneCode": "66383", "latitude": 5.002787, "longitude": -76.003200}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66400', 'La Virginia', 840, '{"daneCode": "66400", "latitude": 4.896624, "longitude": -75.880394}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66440', 'Marsella', 841, '{"daneCode": "66440", "latitude": 4.935771, "longitude": -75.738790}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66456', 'Mistrató', 842, '{"daneCode": "66456", "latitude": 5.297039, "longitude": -75.882886}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66572', 'Pueblo Rico', 843, '{"daneCode": "66572", "latitude": 5.222043, "longitude": -76.030801}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66594', 'Quinchía', 844, '{"daneCode": "66594", "latitude": 5.340456, "longitude": -75.730431}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66682', 'Santa Rosa De Cabal', 845, '{"daneCode": "66682", "latitude": 4.876271, "longitude": -75.623268}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '66687', 'Santuario', 846, '{"daneCode": "66687", "latitude": 5.074911, "longitude": -75.964628}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '66'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68001', 'Bucaramanga', 847, '{"daneCode": "68001", "latitude": 7.116470, "longitude": -73.132562}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68013', 'Aguada', 848, '{"daneCode": "68013", "latitude": 6.162355, "longitude": -73.523132}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68020', 'Albania', 849, '{"daneCode": "68020", "latitude": 5.759166, "longitude": -73.913360}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68051', 'Aratoca', 850, '{"daneCode": "68051", "latitude": 6.694418, "longitude": -73.017860}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68077', 'Barbosa', 851, '{"daneCode": "68077", "latitude": 5.932531, "longitude": -73.615965}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68079', 'Barichara', 852, '{"daneCode": "68079", "latitude": 6.634111, "longitude": -73.223047}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68081', 'Barrancabermeja', 853, '{"daneCode": "68081", "latitude": 7.064857, "longitude": -73.849243}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68092', 'Betulia', 854, '{"daneCode": "68092", "latitude": 6.899525, "longitude": -73.283669}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68101', 'Bolívar', 855, '{"daneCode": "68101", "latitude": 5.988953, "longitude": -73.771346}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68121', 'Cabrera', 856, '{"daneCode": "68121", "latitude": 6.592118, "longitude": -73.246475}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68132', 'California', 857, '{"daneCode": "68132", "latitude": 7.347989, "longitude": -72.946491}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68147', 'Capitanejo', 858, '{"daneCode": "68147", "latitude": 6.527394, "longitude": -72.695427}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68152', 'Carcasí', 859, '{"daneCode": "68152", "latitude": 6.629016, "longitude": -72.627099}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68160', 'Cepitá', 860, '{"daneCode": "68160", "latitude": 6.753518, "longitude": -72.973536}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68162', 'Cerrito', 861, '{"daneCode": "68162", "latitude": 6.840405, "longitude": -72.694851}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68167', 'Charalá', 862, '{"daneCode": "68167", "latitude": 6.284339, "longitude": -73.146873}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68169', 'Charta', 863, '{"daneCode": "68169", "latitude": 7.280820, "longitude": -72.968798}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68176', 'Chima', 864, '{"daneCode": "68176", "latitude": 6.344348, "longitude": -73.373656}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68179', 'Chipatá', 865, '{"daneCode": "68179", "latitude": 6.062521, "longitude": -73.637111}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68190', 'Cimitarra', 866, '{"daneCode": "68190", "latitude": 6.320886, "longitude": -73.953011}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68207', 'Concepción', 867, '{"daneCode": "68207", "latitude": 6.768908, "longitude": -72.694567}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68209', 'Confines', 868, '{"daneCode": "68209", "latitude": 6.357327, "longitude": -73.240554}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68211', 'Contratación', 869, '{"daneCode": "68211", "latitude": 6.290561, "longitude": -73.474426}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68217', 'Coromoro', 870, '{"daneCode": "68217", "latitude": 6.294999, "longitude": -73.040816}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68229', 'Curití', 871, '{"daneCode": "68229", "latitude": 6.605099, "longitude": -73.069383}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68235', 'El Carmen De Chucurí', 872, '{"daneCode": "68235", "latitude": 6.700038, "longitude": -73.510660}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68245', 'El Guacamayo', 873, '{"daneCode": "68245", "latitude": 6.245111, "longitude": -73.496908}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68250', 'El Peñón', 874, '{"daneCode": "68250", "latitude": 6.055370, "longitude": -73.815532}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68255', 'El Playón', 875, '{"daneCode": "68255", "latitude": 7.470715, "longitude": -73.202870}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68264', 'Encino', 876, '{"daneCode": "68264", "latitude": 6.137429, "longitude": -73.098749}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68266', 'Enciso', 877, '{"daneCode": "68266", "latitude": 6.668034, "longitude": -72.699647}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68271', 'Florián', 878, '{"daneCode": "68271", "latitude": 5.804659, "longitude": -73.971430}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68276', 'Floridablanca', 879, '{"daneCode": "68276", "latitude": 7.072329, "longitude": -73.099104}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68296', 'Galán', 880, '{"daneCode": "68296", "latitude": 6.638423, "longitude": -73.287769}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68298', 'Gámbita', 881, '{"daneCode": "68298", "latitude": 5.945998, "longitude": -73.344185}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68307', 'Girón', 882, '{"daneCode": "68307", "latitude": 7.070432, "longitude": -73.166832}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68318', 'Guaca', 883, '{"daneCode": "68318", "latitude": 6.876563, "longitude": -72.856322}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68320', 'Guadalupe', 884, '{"daneCode": "68320", "latitude": 6.245847, "longitude": -73.419292}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68322', 'Guapotá', 885, '{"daneCode": "68322", "latitude": 6.308635, "longitude": -73.320732}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68324', 'Guavatá', 886, '{"daneCode": "68324", "latitude": 5.954348, "longitude": -73.700906}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68327', 'Güepsa', 887, '{"daneCode": "68327", "latitude": 6.025013, "longitude": -73.575146}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68344', 'Hato', 888, '{"daneCode": "68344", "latitude": 6.543957, "longitude": -73.308399}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68368', 'Jesús María', 889, '{"daneCode": "68368", "latitude": 5.876497, "longitude": -73.783396}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68370', 'Jordán', 890, '{"daneCode": "68370", "latitude": 6.732727, "longitude": -73.096053}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68377', 'La Belleza', 891, '{"daneCode": "68377", "latitude": 5.859250, "longitude": -73.965494}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68385', 'Landázuri', 892, '{"daneCode": "68385", "latitude": 6.218812, "longitude": -73.811359}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68397', 'La Paz', 893, '{"daneCode": "68397", "latitude": 6.178509, "longitude": -73.589590}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68406', 'Lebrija', 894, '{"daneCode": "68406", "latitude": 7.113351, "longitude": -73.219524}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68418', 'Los Santos', 895, '{"daneCode": "68418", "latitude": 6.755203, "longitude": -73.102739}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68425', 'Macaravita', 896, '{"daneCode": "68425", "latitude": 6.506580, "longitude": -72.593105}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68432', 'Málaga', 897, '{"daneCode": "68432", "latitude": 6.703081, "longitude": -72.732089}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68444', 'Matanza', 898, '{"daneCode": "68444", "latitude": 7.323175, "longitude": -73.015566}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68464', 'Mogotes', 899, '{"daneCode": "68464", "latitude": 6.475246, "longitude": -72.969807}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68468', 'Molagavita', 900, '{"daneCode": "68468", "latitude": 6.674320, "longitude": -72.809175}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68498', 'Ocamonte', 901, '{"daneCode": "68498", "latitude": 6.339988, "longitude": -73.122563}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68500', 'Oiba', 902, '{"daneCode": "68500", "latitude": 6.265210, "longitude": -73.299791}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68502', 'Onzaga', 903, '{"daneCode": "68502", "latitude": 6.344104, "longitude": -72.816766}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68522', 'Palmar', 904, '{"daneCode": "68522", "latitude": 6.537789, "longitude": -73.291090}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68524', 'Palmas Del Socorro', 905, '{"daneCode": "68524", "latitude": 6.406139, "longitude": -73.287764}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68533', 'Páramo', 906, '{"daneCode": "68533", "latitude": 6.416811, "longitude": -73.170220}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68547', 'Piedecuesta', 907, '{"daneCode": "68547", "latitude": 6.997245, "longitude": -73.054795}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68549', 'Pinchote', 908, '{"daneCode": "68549", "latitude": 6.531552, "longitude": -73.174209}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68572', 'Puente Nacional', 909, '{"daneCode": "68572", "latitude": 5.878381, "longitude": -73.677567}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68573', 'Puerto Parra', 910, '{"daneCode": "68573", "latitude": 6.650785, "longitude": -74.056129}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68575', 'Puerto Wilches', 911, '{"daneCode": "68575", "latitude": 7.344057, "longitude": -73.899909}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68615', 'Rionegro', 912, '{"daneCode": "68615", "latitude": 7.265014, "longitude": -73.150177}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68655', 'Sabana De Torres', 913, '{"daneCode": "68655", "latitude": 7.391919, "longitude": -73.499060}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68669', 'San Andrés', 914, '{"daneCode": "68669", "latitude": 6.811511, "longitude": -72.848864}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68673', 'San Benito', 915, '{"daneCode": "68673", "latitude": 6.126656, "longitude": -73.509070}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68679', 'San Gil', 916, '{"daneCode": "68679", "latitude": 6.551952, "longitude": -73.134776}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68682', 'San Joaquín', 917, '{"daneCode": "68682", "latitude": 6.427548, "longitude": -72.867638}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68684', 'San José De Miranda', 918, '{"daneCode": "68684", "latitude": 6.658995, "longitude": -72.733616}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68686', 'San Miguel', 919, '{"daneCode": "68686", "latitude": 6.575315, "longitude": -72.644123}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68689', 'San Vicente De Chucurí', 920, '{"daneCode": "68689", "latitude": 6.880383, "longitude": -73.411024}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68705', 'Santa Bárbara', 921, '{"daneCode": "68705", "latitude": 6.990996, "longitude": -72.907445}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68720', 'Santa Helena Del Opón', 922, '{"daneCode": "68720", "latitude": 6.339565, "longitude": -73.616716}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68745', 'Simacota', 923, '{"daneCode": "68745", "latitude": 6.443469, "longitude": -73.337368}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68755', 'Socorro', 924, '{"daneCode": "68755", "latitude": 6.463870, "longitude": -73.261198}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68770', 'Suaita', 925, '{"daneCode": "68770", "latitude": 6.101329, "longitude": -73.441650}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68773', 'Sucre', 926, '{"daneCode": "68773", "latitude": 5.918743, "longitude": -73.790975}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68780', 'Suratá', 927, '{"daneCode": "68780", "latitude": 7.366580, "longitude": -72.984232}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68820', 'Tona', 928, '{"daneCode": "68820", "latitude": 7.201417, "longitude": -72.967023}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68855', 'Valle De San José', 929, '{"daneCode": "68855", "latitude": 6.448028, "longitude": -73.143507}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68861', 'Vélez', 930, '{"daneCode": "68861", "latitude": 6.009275, "longitude": -73.672447}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68867', 'Vetas', 931, '{"daneCode": "68867", "latitude": 7.309810, "longitude": -72.871041}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68872', 'Villanueva', 932, '{"daneCode": "68872", "latitude": 6.670078, "longitude": -73.174307}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '68895', 'Zapatoca', 933, '{"daneCode": "68895", "latitude": 6.814387, "longitude": -73.268034}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '68'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70001', 'Sincelejo', 934, '{"daneCode": "70001", "latitude": 9.302322, "longitude": -75.395445}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70110', 'Buenavista', 935, '{"daneCode": "70110", "latitude": 9.319794, "longitude": -74.972827}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70124', 'Caimito', 936, '{"daneCode": "70124", "latitude": 8.789324, "longitude": -75.117141}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70204', 'Colosó', 937, '{"daneCode": "70204", "latitude": 9.494192, "longitude": -75.353256}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70215', 'Corozal', 938, '{"daneCode": "70215", "latitude": 9.318749, "longitude": -75.293048}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70221', 'Coveñas', 939, '{"daneCode": "70221", "latitude": 9.402779, "longitude": -75.680158}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70230', 'Chalán', 940, '{"daneCode": "70230", "latitude": 9.545352, "longitude": -75.312697}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70233', 'El Roble', 941, '{"daneCode": "70233", "latitude": 9.100647, "longitude": -75.198378}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70235', 'Galeras', 942, '{"daneCode": "70235", "latitude": 9.160379, "longitude": -75.049590}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70265', 'Guaranda', 943, '{"daneCode": "70265", "latitude": 8.468556, "longitude": -74.537749}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70400', 'La Unión', 944, '{"daneCode": "70400", "latitude": 8.853975, "longitude": -75.276056}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70418', 'Los Palmitos', 945, '{"daneCode": "70418", "latitude": 9.380269, "longitude": -75.268716}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70429', 'Majagual', 946, '{"daneCode": "70429", "latitude": 8.541163, "longitude": -74.628077}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70473', 'Morroa', 947, '{"daneCode": "70473", "latitude": 9.331395, "longitude": -75.305949}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70508', 'Ovejas', 948, '{"daneCode": "70508", "latitude": 9.527176, "longitude": -75.229037}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70523', 'Palmito', 949, '{"daneCode": "70523", "latitude": 9.333157, "longitude": -75.541264}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70670', 'Sampués', 950, '{"daneCode": "70670", "latitude": 9.183193, "longitude": -75.380222}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70678', 'San Benito Abad', 951, '{"daneCode": "70678", "latitude": 8.930108, "longitude": -75.031089}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70702', 'San Juan De Betulia', 952, '{"daneCode": "70702", "latitude": 9.273066, "longitude": -75.243565}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70708', 'San Marcos', 953, '{"daneCode": "70708", "latitude": 8.661774, "longitude": -75.133831}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70713', 'San Onofre', 954, '{"daneCode": "70713", "latitude": 9.736955, "longitude": -75.522398}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70717', 'San Pedro', 955, '{"daneCode": "70717", "latitude": 9.396250, "longitude": -75.063647}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70742', 'San Luis De Sincé', 956, '{"daneCode": "70742", "latitude": 9.244308, "longitude": -75.145999}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70771', 'Sucre', 957, '{"daneCode": "70771", "latitude": 8.811737, "longitude": -74.723175}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70820', 'Santiago De Tolú', 958, '{"daneCode": "70820", "latitude": 9.525387, "longitude": -75.581112}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '70823', 'San José De Toluviejo', 959, '{"daneCode": "70823", "latitude": 9.451819, "longitude": -75.440850}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '70'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73001', 'Ibagué', 960, '{"daneCode": "73001", "latitude": 4.432248, "longitude": -75.194250}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73024', 'Alpujarra', 961, '{"daneCode": "73024", "latitude": 3.391548, "longitude": -74.932900}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73026', 'Alvarado', 962, '{"daneCode": "73026", "latitude": 4.567356, "longitude": -74.953418}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73030', 'Ambalema', 963, '{"daneCode": "73030", "latitude": 4.782682, "longitude": -74.764429}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73043', 'Anzoátegui', 964, '{"daneCode": "73043", "latitude": 4.631756, "longitude": -75.093772}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73055', 'Armero', 965, '{"daneCode": "73055", "latitude": 5.030744, "longitude": -74.884438}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73067', 'Ataco', 966, '{"daneCode": "73067", "latitude": 3.590591, "longitude": -75.382545}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73124', 'Cajamarca', 967, '{"daneCode": "73124", "latitude": 4.438812, "longitude": -75.431971}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73148', 'Carmen De Apicalá', 968, '{"daneCode": "73148", "latitude": 4.152334, "longitude": -74.717633}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73152', 'Casabianca', 969, '{"daneCode": "73152", "latitude": 5.078465, "longitude": -75.120966}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73168', 'Chaparral', 970, '{"daneCode": "73168", "latitude": 3.722918, "longitude": -75.480765}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73200', 'Coello', 971, '{"daneCode": "73200", "latitude": 4.287276, "longitude": -74.898464}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73217', 'Coyaima', 972, '{"daneCode": "73217", "latitude": 3.798036, "longitude": -75.193862}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73226', 'Cunday', 973, '{"daneCode": "73226", "latitude": 4.059259, "longitude": -74.692227}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73236', 'Dolores', 974, '{"daneCode": "73236", "latitude": 3.539072, "longitude": -74.896761}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73268', 'Espinal', 975, '{"daneCode": "73268", "latitude": 4.151314, "longitude": -74.885446}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73270', 'Falan', 976, '{"daneCode": "73270", "latitude": 5.123104, "longitude": -74.953007}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73275', 'Flandes', 977, '{"daneCode": "73275", "latitude": 4.276373, "longitude": -74.818763}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73283', 'Fresno', 978, '{"daneCode": "73283", "latitude": 5.153576, "longitude": -75.035722}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73319', 'Guamo', 979, '{"daneCode": "73319", "latitude": 4.030992, "longitude": -74.968135}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73347', 'Herveo', 980, '{"daneCode": "73347", "latitude": 5.080228, "longitude": -75.177151}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73349', 'Honda', 981, '{"daneCode": "73349", "latitude": 5.211816, "longitude": -74.756990}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73352', 'Icononzo', 982, '{"daneCode": "73352", "latitude": 4.176487, "longitude": -74.531969}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73408', 'Lérida', 983, '{"daneCode": "73408", "latitude": 4.862046, "longitude": -74.910716}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73411', 'Líbano', 984, '{"daneCode": "73411", "latitude": 4.920420, "longitude": -75.061959}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73443', 'San Sebastián De Mariquita', 985, '{"daneCode": "73443", "latitude": 5.199708, "longitude": -74.889276}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73449', 'Melgar', 986, '{"daneCode": "73449", "latitude": 4.203655, "longitude": -74.641317}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73461', 'Murillo', 987, '{"daneCode": "73461", "latitude": 4.874341, "longitude": -75.171022}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73483', 'Natagaima', 988, '{"daneCode": "73483", "latitude": 3.624324, "longitude": -75.093182}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73504', 'Ortega', 989, '{"daneCode": "73504", "latitude": 3.934916, "longitude": -75.222601}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73520', 'Palocabildo', 990, '{"daneCode": "73520", "latitude": 5.120918, "longitude": -75.022167}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73547', 'Piedras', 991, '{"daneCode": "73547", "latitude": 4.543951, "longitude": -74.878106}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73555', 'Planadas', 992, '{"daneCode": "73555", "latitude": 3.197911, "longitude": -75.644163}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73563', 'Prado', 993, '{"daneCode": "73563", "latitude": 3.750939, "longitude": -74.927447}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73585', 'Purificación', 994, '{"daneCode": "73585", "latitude": 3.857246, "longitude": -74.935555}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73616', 'Rioblanco', 995, '{"daneCode": "73616", "latitude": 3.529932, "longitude": -75.644069}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73622', 'Roncesvalles', 996, '{"daneCode": "73622", "latitude": 4.011567, "longitude": -75.605959}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73624', 'Rovira', 997, '{"daneCode": "73624", "latitude": 4.239019, "longitude": -75.240648}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73671', 'Saldaña', 998, '{"daneCode": "73671", "latitude": 3.929815, "longitude": -75.016852}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73675', 'San Antonio', 999, '{"daneCode": "73675", "latitude": 3.914146, "longitude": -75.480074}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73678', 'San Luis', 1000, '{"daneCode": "73678", "latitude": 4.133721, "longitude": -75.095804}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73686', 'Santa Isabel', 1001, '{"daneCode": "73686", "latitude": 4.713606, "longitude": -75.097934}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73770', 'Suárez', 1002, '{"daneCode": "73770", "latitude": 4.048891, "longitude": -74.831885}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73854', 'Valle De San Juan', 1003, '{"daneCode": "73854", "latitude": 4.197494, "longitude": -75.115669}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73861', 'Venadillo', 1004, '{"daneCode": "73861", "latitude": 4.717878, "longitude": -74.929333}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73870', 'Villahermosa', 1005, '{"daneCode": "73870", "latitude": 5.030452, "longitude": -75.117729}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '73873', 'Villarrica', 1006, '{"daneCode": "73873", "latitude": 3.936902, "longitude": -74.600285}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '73'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76001', 'Santiago De Cali', 1007, '{"daneCode": "76001", "latitude": 3.413686, "longitude": -76.521330}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76020', 'Alcalá', 1008, '{"daneCode": "76020", "latitude": 4.674994, "longitude": -75.779792}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76036', 'Andalucía', 1009, '{"daneCode": "76036", "latitude": 4.171713, "longitude": -76.167925}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76041', 'Ansermanuevo', 1010, '{"daneCode": "76041", "latitude": 4.794984, "longitude": -75.992003}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76054', 'Argelia', 1011, '{"daneCode": "76054", "latitude": 4.726945, "longitude": -76.119905}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76100', 'Bolívar', 1012, '{"daneCode": "76100", "latitude": 4.337846, "longitude": -76.183583}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76109', 'Buenaventura', 1013, '{"daneCode": "76109", "latitude": 3.875708, "longitude": -77.010740}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76111', 'Guadalajara De Buga', 1014, '{"daneCode": "76111", "latitude": 3.900736, "longitude": -76.298979}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76113', 'Bugalagrande', 1015, '{"daneCode": "76113", "latitude": 4.208358, "longitude": -76.156820}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76122', 'Caicedonia', 1016, '{"daneCode": "76122", "latitude": 4.334808, "longitude": -75.830594}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76126', 'Calima', 1017, '{"daneCode": "76126", "latitude": 3.933664, "longitude": -76.484132}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76130', 'Candelaria', 1018, '{"daneCode": "76130", "latitude": 3.408354, "longitude": -76.346519}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76147', 'Cartago', 1019, '{"daneCode": "76147", "latitude": 4.742192, "longitude": -75.924374}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76233', 'Dagua', 1020, '{"daneCode": "76233", "latitude": 3.657318, "longitude": -76.688860}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76243', 'El Águila', 1021, '{"daneCode": "76243", "latitude": 4.906062, "longitude": -76.042779}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76246', 'El Cairo', 1022, '{"daneCode": "76246", "latitude": 4.760874, "longitude": -76.221611}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76248', 'El Cerrito', 1023, '{"daneCode": "76248", "latitude": 3.684229, "longitude": -76.311972}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76250', 'El Dovio', 1024, '{"daneCode": "76250", "latitude": 4.510452, "longitude": -76.237084}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76275', 'Florida', 1025, '{"daneCode": "76275", "latitude": 3.324118, "longitude": -76.234199}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76306', 'Ginebra', 1026, '{"daneCode": "76306", "latitude": 3.724181, "longitude": -76.268068}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76318', 'Guacarí', 1027, '{"daneCode": "76318", "latitude": 3.761815, "longitude": -76.330911}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76364', 'Jamundí', 1028, '{"daneCode": "76364", "latitude": 3.258751, "longitude": -76.538472}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76377', 'La Cumbre', 1029, '{"daneCode": "76377", "latitude": 3.649268, "longitude": -76.568050}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76400', 'La Unión', 1030, '{"daneCode": "76400", "latitude": 4.533869, "longitude": -76.099661}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76403', 'La Victoria', 1031, '{"daneCode": "76403", "latitude": 4.523603, "longitude": -76.036529}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76497', 'Obando', 1032, '{"daneCode": "76497", "latitude": 4.575712, "longitude": -75.974709}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76520', 'Palmira', 1033, '{"daneCode": "76520", "latitude": 3.531544, "longitude": -76.298846}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76563', 'Pradera', 1034, '{"daneCode": "76563", "latitude": 3.419793, "longitude": -76.241799}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76606', 'Restrepo', 1035, '{"daneCode": "76606", "latitude": 3.821351, "longitude": -76.523329}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76616', 'Riofrío', 1036, '{"daneCode": "76616", "latitude": 4.156908, "longitude": -76.288313}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76622', 'Roldanillo', 1037, '{"daneCode": "76622", "latitude": 4.413601, "longitude": -76.152277}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76670', 'San Pedro', 1038, '{"daneCode": "76670", "latitude": 3.995073, "longitude": -76.228692}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76736', 'Sevilla', 1039, '{"daneCode": "76736", "latitude": 4.270714, "longitude": -75.931629}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76823', 'Toro', 1040, '{"daneCode": "76823", "latitude": 4.608085, "longitude": -76.076859}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76828', 'Trujillo', 1041, '{"daneCode": "76828", "latitude": 4.212037, "longitude": -76.318818}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76834', 'Tuluá', 1042, '{"daneCode": "76834", "latitude": 4.085399, "longitude": -76.197731}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76845', 'Ulloa', 1043, '{"daneCode": "76845", "latitude": 4.703623, "longitude": -75.737808}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76863', 'Versalles', 1044, '{"daneCode": "76863", "latitude": 4.575019, "longitude": -76.199203}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76869', 'Vijes', 1045, '{"daneCode": "76869", "latitude": 3.698686, "longitude": -76.441804}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76890', 'Yotoco', 1046, '{"daneCode": "76890", "latitude": 3.861241, "longitude": -76.382698}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76892', 'Yumbo', 1047, '{"daneCode": "76892", "latitude": 3.540097, "longitude": -76.499893}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '76895', 'Zarzal', 1048, '{"daneCode": "76895", "latitude": 4.392658, "longitude": -76.070795}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '76'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '81001', 'Arauca', 1049, '{"daneCode": "81001", "latitude": 7.072726, "longitude": -70.747408}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '81'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '81065', 'Arauquita', 1050, '{"daneCode": "81065", "latitude": 7.027020, "longitude": -71.426733}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '81'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '81220', 'Cravo Norte', 1051, '{"daneCode": "81220", "latitude": 6.303913, "longitude": -70.204286}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '81'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '81300', 'Fortul', 1052, '{"daneCode": "81300", "latitude": 6.796695, "longitude": -71.768770}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '81'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '81591', 'Puerto Rondón', 1053, '{"daneCode": "81591", "latitude": 6.281461, "longitude": -71.103390}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '81'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '81736', 'Saravena', 1054, '{"daneCode": "81736", "latitude": 6.953926, "longitude": -71.872812}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '81'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '81794', 'Tame', 1055, '{"daneCode": "81794", "latitude": 6.453324, "longitude": -71.754427}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '81'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85001', 'Yopal', 1056, '{"daneCode": "85001", "latitude": 5.327102, "longitude": -72.396132}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85010', 'Aguazul', 1057, '{"daneCode": "85010", "latitude": 5.172641, "longitude": -72.546838}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85015', 'Chámeza', 1058, '{"daneCode": "85015", "latitude": 5.214527, "longitude": -72.870160}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85125', 'Hato Corozal', 1059, '{"daneCode": "85125", "latitude": 6.154099, "longitude": -71.764213}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85136', 'La Salina', 1060, '{"daneCode": "85136", "latitude": 6.127762, "longitude": -72.334978}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85139', 'Maní', 1061, '{"daneCode": "85139", "latitude": 4.816810, "longitude": -72.281384}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85162', 'Monterrey', 1062, '{"daneCode": "85162", "latitude": 4.877017, "longitude": -72.894065}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85225', 'Nunchía', 1063, '{"daneCode": "85225", "latitude": 5.636474, "longitude": -72.195323}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85230', 'Orocué', 1064, '{"daneCode": "85230", "latitude": 4.790258, "longitude": -71.338533}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85250', 'Paz De Ariporo', 1065, '{"daneCode": "85250", "latitude": 5.879827, "longitude": -71.890348}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85263', 'Pore', 1066, '{"daneCode": "85263", "latitude": 5.727730, "longitude": -71.992860}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85279', 'Recetor', 1067, '{"daneCode": "85279", "latitude": 5.229181, "longitude": -72.760991}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85300', 'Sabanalarga', 1068, '{"daneCode": "85300", "latitude": 4.854787, "longitude": -73.038696}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85315', 'Sácama', 1069, '{"daneCode": "85315", "latitude": 6.096738, "longitude": -72.250157}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85325', 'San Luis De Palenque', 1070, '{"daneCode": "85325", "latitude": 5.422397, "longitude": -71.732198}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85400', 'Támara', 1071, '{"daneCode": "85400", "latitude": 5.829543, "longitude": -72.161650}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85410', 'Tauramena', 1072, '{"daneCode": "85410", "latitude": 5.018977, "longitude": -72.746620}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85430', 'Trinidad', 1073, '{"daneCode": "85430", "latitude": 5.412178, "longitude": -71.662812}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '85440', 'Villanueva', 1074, '{"daneCode": "85440", "latitude": 4.610350, "longitude": -72.927797}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '85'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86001', 'Mocoa', 1075, '{"daneCode": "86001", "latitude": 1.151172, "longitude": -76.654238}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86219', 'Colón', 1076, '{"daneCode": "86219", "latitude": 1.190133, "longitude": -76.972566}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86320', 'Orito', 1077, '{"daneCode": "86320", "latitude": 0.663593, "longitude": -76.873276}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86568', 'Puerto Asís', 1078, '{"daneCode": "86568", "latitude": 0.505627, "longitude": -76.496887}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86569', 'Puerto Caicedo', 1079, '{"daneCode": "86569", "latitude": 0.687784, "longitude": -76.606118}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86571', 'Puerto Guzmán', 1080, '{"daneCode": "86571", "latitude": 0.962854, "longitude": -76.407663}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86573', 'Puerto Leguízamo', 1081, '{"daneCode": "86573", "latitude": -0.192318, "longitude": -74.781842}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86749', 'Sibundoy', 1082, '{"daneCode": "86749", "latitude": 1.200260, "longitude": -76.917814}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86755', 'San Francisco', 1083, '{"daneCode": "86755", "latitude": 1.174194, "longitude": -76.879283}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86757', 'San Miguel', 1084, '{"daneCode": "86757", "latitude": 0.343460, "longitude": -76.912170}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86760', 'Santiago', 1085, '{"daneCode": "86760", "latitude": 1.147076, "longitude": -77.002641}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86865', 'Valle Del Guamuez', 1086, '{"daneCode": "86865", "latitude": 0.423506, "longitude": -76.906751}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '86885', 'Villagarzón', 1087, '{"daneCode": "86885", "latitude": 1.028821, "longitude": -76.617210}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '86'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '88001', 'San Andrés', 1088, '{"daneCode": "88001", "latitude": 12.578108, "longitude": -81.707181}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '88'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '88564', 'Providencia', 1089, '{"daneCode": "88564", "latitude": 13.373185, "longitude": -81.368386}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '88'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91001', 'Leticia', 1090, '{"daneCode": "91001", "latitude": -4.198950, "longitude": -69.941721}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91263', 'El Encanto', 1091, '{"daneCode": "91263", "latitude": -1.748060, "longitude": -73.207114}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91405', 'La Chorrera', 1092, '{"daneCode": "91405", "latitude": -1.442617, "longitude": -72.791889}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91407', 'La Pedrera', 1093, '{"daneCode": "91407", "latitude": -1.320301, "longitude": -69.585499}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91430', 'La Victoria', 1094, '{"daneCode": "91430", "latitude": 0.054936, "longitude": -71.223208}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91460', 'Mirití - Paraná', 1095, '{"daneCode": "91460", "latitude": -0.888833, "longitude": -70.988930}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91530', 'Puerto Alegría', 1096, '{"daneCode": "91530", "latitude": -1.005674, "longitude": -74.014461}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91536', 'Puerto Arica', 1097, '{"daneCode": "91536", "latitude": -2.147039, "longitude": -71.752186}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91540', 'Puerto Nariño', 1098, '{"daneCode": "91540", "latitude": -3.779934, "longitude": -70.364937}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91669', 'Puerto Santander', 1099, '{"daneCode": "91669", "latitude": -0.621184, "longitude": -72.384213}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '91798', 'Tarapacá', 1100, '{"daneCode": "91798", "latitude": -2.890126, "longitude": -69.741745}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '91'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '94001', 'Inírida', 1101, '{"daneCode": "94001", "latitude": 3.866764, "longitude": -67.918613}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '94'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '94343', 'Barrancominas', 1102, '{"daneCode": "94343", "latitude": 3.494178, "longitude": -69.814066}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '94'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '94883', 'San Felipe', 1103, '{"daneCode": "94883", "latitude": 1.912495, "longitude": -67.067848}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '94'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '94884', 'Puerto Colombia', 1104, '{"daneCode": "94884", "latitude": 2.726438, "longitude": -67.566774}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '94'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '94885', 'La Guadalupe', 1105, '{"daneCode": "94885", "latitude": 1.632464, "longitude": -66.963692}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '94'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '94886', 'Cacahual', 1106, '{"daneCode": "94886", "latitude": 3.526170, "longitude": -67.413312}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '94'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '94887', 'Pana Pana', 1107, '{"daneCode": "94887", "latitude": 1.865668, "longitude": -69.009900}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '94'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '94888', 'Morichal', 1108, '{"daneCode": "94888", "latitude": 2.265132, "longitude": -69.919404}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '94'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '95001', 'San José Del Guaviare', 1109, '{"daneCode": "95001", "latitude": 2.565932, "longitude": -72.639254}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '95'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '95015', 'Calamar', 1110, '{"daneCode": "95015", "latitude": 1.960982, "longitude": -72.655197}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '95'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '95025', 'El Retorno', 1111, '{"daneCode": "95025", "latitude": 2.330164, "longitude": -72.627304}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '95'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '95200', 'Miraflores', 1112, '{"daneCode": "95200", "latitude": 1.337539, "longitude": -71.950416}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '95'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '97001', 'Mitú', 1113, '{"daneCode": "97001", "latitude": 1.253151, "longitude": -70.232641}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '97'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '97161', 'Carurú', 1114, '{"daneCode": "97161", "latitude": 1.016116, "longitude": -71.302210}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '97'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '97511', 'Pacoa', 1115, '{"daneCode": "97511", "latitude": 0.020698, "longitude": -71.004339}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '97'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '97666', 'Taraira', 1116, '{"daneCode": "97666", "latitude": -0.564984, "longitude": -69.635497}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '97'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '97777', 'Papunahua', 1117, '{"daneCode": "97777", "latitude": 1.908124, "longitude": -70.760910}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '97'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '97889', 'Yavaraté', 1118, '{"daneCode": "97889", "latitude": 0.609142, "longitude": -69.203337}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '97'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '99001', 'Puerto Carreño', 1119, '{"daneCode": "99001", "latitude": 6.186636, "longitude": -67.487095}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '99'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '99524', 'La Primavera', 1120, '{"daneCode": "99524", "latitude": 5.486309, "longitude": -70.410515}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '99'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '99624', 'Santa Rosalía', 1121, '{"daneCode": "99624", "latitude": 5.136393, "longitude": -70.859499}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '99'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
INSERT INTO catalog_item (catalog_code, parent_id, item_code, name, order_index, extra_data, created_by)
SELECT 'CITY', id, '99773', 'Cumaribo', 1122, '{"daneCode": "99773", "latitude": 4.446352, "longitude": -69.795533}', 'system'
FROM catalog_item WHERE catalog_code = 'DEPARTMENT' AND item_code = '99'
  AND parent_id = (SELECT id FROM catalog_item WHERE catalog_code = 'COUNTRY' AND item_code = 'CO');
