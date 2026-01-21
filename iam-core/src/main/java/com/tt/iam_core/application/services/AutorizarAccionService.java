package com.tt.iam_core.application.service;

import com.tt.iam_core.domain.model.Usuario;
import com.tt.iam_core.domain.model.UsuarioId;
import com.tt.iam_core.domain.ports.in.AutorizarAccionUseCase;
import com.tt.iam_core.domain.ports.out.UsuarioRepository;

public class AutorizarAccionService implements AutorizarAccionUseCase {

    private final UsuarioRepository usuarioRepository;

    public AutorizarAccionService(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

   @Override
    public boolean autorizar(UsuarioId usuarioId, String accion, String recurso) {

        Usuario usuario = usuarioRepository
                .findById(usuarioId)
                .orElseThrow(() -> new IllegalStateException("Usuario no existe"));

        return usuario.tienePermiso(accion, recurso);
    }
}