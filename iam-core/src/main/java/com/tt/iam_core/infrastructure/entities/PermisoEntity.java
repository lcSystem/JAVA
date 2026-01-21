package com.tt.iam_core.infrastructure.entities;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "permiso")
public class PermisoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 50)
    private String accion;

    @Column(nullable = false, length = 50)
    private String recurso;

    @Column
    private String descripcion;

    @ManyToMany(mappedBy = "permisos")
    private Set<RolEntity> roles;

    @OneToMany(mappedBy = "permiso", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<MenuPermisoEntity> menus;

    // getters y setters
}
