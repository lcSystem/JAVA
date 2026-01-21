package com.tt.iam_core.domain.model;

public class Organizacion {

    private OrganizacionId id;
    private String nombre;

    public Organizacion(OrganizacionId id, String nombre) {
        this.id = id;
        this.nombre = nombre;
    }
}
