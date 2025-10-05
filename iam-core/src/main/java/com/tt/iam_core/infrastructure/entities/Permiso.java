package com.tt.iam_core.infrastructure.entities;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "permiso")
public class Permiso {

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
    private Set<Rol> roles;

    @ManyToMany(mappedBy = "permisos")
    private Set<Menu> menus;

    // Getters y Setters
}
