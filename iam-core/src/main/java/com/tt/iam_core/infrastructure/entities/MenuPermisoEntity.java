package com.tt.iam_core.infrastructure.entities;

import jakarta.persistence.*;

@Entity
@Table(name = "asignacion_menu_permiso")
public class MenuPermisoEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "menu_id", nullable = false)
    private MenuEntity menu;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "permiso_id", nullable = false)
    private PermisoEntity permiso;

    // getters y setters
}
