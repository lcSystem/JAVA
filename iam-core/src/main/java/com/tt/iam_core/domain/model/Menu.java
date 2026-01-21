package com.tt.iam_core.domain.model;

import java.util.Set;

public class Menu {

    private MenuId id;
    private String nombre;
    private String ruta;
    private String icono;
    private Menu parent;
    private Integer orden;
    private EstadoMenu estado;
    private Set<Permiso> permisos;
    private Set<Menu> subMenus;

    public Menu(
            MenuId id,
            String nombre,
            String ruta,
            String icono,
            Menu parent,
            Integer orden,
            EstadoMenu estado
    ) {
        this.id = id;
        this.nombre = nombre;
        this.ruta = ruta;
        this.icono = icono;
        this.parent = parent;
        this.orden = orden;
        this.estado = estado;
    }

    public boolean estaActivo() {
        return EstadoMenu.ACTIVO.equals(this.estado);
    }

    // getters
}
