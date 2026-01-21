package com.tt.iam_core.domain.ports.in;

import com.tt.iam_core.domain.model.UsuarioId;

public interface AutorizarAccionUseCase {
    boolean ejecutar(UsuarioId usuarioId, String accion, String recurso);
}
