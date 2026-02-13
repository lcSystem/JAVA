CREATE TABLE permiso (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    accion VARCHAR(100),
    recurso VARCHAR(100),
    descripcion VARCHAR(255)
);

CREATE TABLE asignacion_rol_permiso (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    rol_id INT,
    permiso_id BIGINT,
    CONSTRAINT fk_rol_permiso_rol FOREIGN KEY (rol_id) REFERENCES roles (role_id),
    CONSTRAINT fk_rol_permiso_permiso FOREIGN KEY (permiso_id) REFERENCES permiso (id)
);