CREATE TABLE evento_auditoria (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    accion VARCHAR(100),
    recurso VARCHAR(100),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip VARCHAR(45),
    resultado VARCHAR(100),
    metadata JSON,
    CONSTRAINT fk_audit_usuario FOREIGN KEY (usuario_id) REFERENCES users (user_id)
);