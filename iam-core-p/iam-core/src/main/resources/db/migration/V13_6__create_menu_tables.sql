CREATE TABLE menu (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    ruta VARCHAR(255),
    icono VARCHAR(100),
    parent_id BIGINT,
    orden INT,
    estado TINYINT DEFAULT 1,
    CONSTRAINT fk_menu_parent FOREIGN KEY (parent_id) REFERENCES menu (id)
);

CREATE TABLE asignacion_menu_permiso (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    menu_id BIGINT,
    permiso_id BIGINT,
    CONSTRAINT fk_menu_permiso_menu FOREIGN KEY (menu_id) REFERENCES menu (id),
    CONSTRAINT fk_menu_permiso_permiso FOREIGN KEY (permiso_id) REFERENCES permiso (id)
);