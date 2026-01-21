package com.tt.iam_core.domain.model;

import java.util.Set;

public class Rol {

    private final RolId id;
    private final String nombre;
    private final Set<Permiso> permisos;

    public Rol(RolId id, String nombre, Set<Permiso> permisos) {
        this.id = id;
        this.nombre = nombre;
        this.permisos = permisos;
    }

    public boolean tienePermiso(String accion, String recurso) {
        return permisos.stream()
                .anyMatch(p -> p.aplicaA(accion, recurso));
    }
}
