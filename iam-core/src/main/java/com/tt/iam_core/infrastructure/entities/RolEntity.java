package com.tt.iam_core.infrastructure.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "rol")
public class RolEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 50)
    private String nombre;

    @Column
    private String descripcion;

    @Column(nullable = false, length = 20)
    private String estado = "activo";

    @ManyToMany(mappedBy = "roles")
    private java.util.Set<UsuarioEntity> usuarios;

    @ManyToMany
    @JoinTable(name = "asignacion_rol_permiso", joinColumns = @JoinColumn(name = "rol_id"), inverseJoinColumns = @JoinColumn(name = "permiso_id"))
    private java.util.Set<PermisoEntity> permisos;
}
