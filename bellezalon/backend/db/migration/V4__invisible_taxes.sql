-- V4: Invisible Taxes column for selective application
ALTER TABLE productos
ADD COLUMN taxes TEXT DEFAULT NULL AFTER precio_venta;

ALTER TABLE servicios
ADD COLUMN taxes TEXT DEFAULT NULL AFTER precio;