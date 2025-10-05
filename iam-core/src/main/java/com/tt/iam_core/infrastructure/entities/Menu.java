package com.tt.iam_core.infrastructure.entities;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "menu")
public class Menu {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String nombre;

    @Column(length = 255)
    private String ruta;

    @Column(length = 50)
    private String icono;

    @ManyToOne
    @JoinColumn(name = "parent_id")
    private Menu parent;

    @Column
    private Integer orden = 0;

    @Column(nullable = false, length = 20)
    private String estado = "activo";

    @ManyToMany
    @JoinTable(
        name = "asignacion_menu_permiso",
        joinColumns = @JoinColumn(name = "menu_id"),
        inverseJoinColumns = @JoinColumn(name = "permiso_id")
    )
    private Set<Permiso> permisos;

    @OneToMany(mappedBy = "parent")
    private Set<Menu> subMenus;

    // Getters y Setters
}
