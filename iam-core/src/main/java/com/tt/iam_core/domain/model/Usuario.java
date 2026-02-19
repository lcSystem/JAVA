package com.tt.iam_core.domain.model;

import java.util.Set;

public class Usuario {

    private UsuarioId id;
    private String username;
    private String email;
    private String passwordHash;
    private boolean activo;
    private Organizacion organizacion;
    private Set<Rol> roles;

    public Usuario(
            UsuarioId id,
            String username,
            String passwordHash,
            Organizacion organizacion,
            Set<Rol> roles) {
        this.id = id;
        this.username = username;
        this.passwordHash = passwordHash;
        this.organizacion = organizacion;
        this.roles = roles;
        this.activo = true;
    }

    public boolean tienePermiso(String accion, String recurso) {
        return roles.stream()
                .anyMatch(r -> r.tienePermiso(accion, recurso));
    }
}
