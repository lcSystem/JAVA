package com.tt.iam_core.domain.model;

import java.util.Objects;

public class Permiso {

    private final PermisoId id;
    private final String accion;
    private final String recurso;

    public Permiso(PermisoId id, String accion, String recurso) {
        this.id = Objects.requireNonNull(id);
        this.accion = Objects.requireNonNull(accion);
        this.recurso = Objects.requireNonNull(recurso);
    }

    public PermisoId id() {
        return id;
    }

    public boolean aplicaA(String accion, String recurso) {
        return this.accion.equals(accion) && this.recurso.equals(recurso);
    }

    public String clave() {
        return accion + ":" + recurso;
    }
}
