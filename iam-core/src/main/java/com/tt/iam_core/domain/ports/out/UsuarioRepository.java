package com.tt.iam_core.domain.ports.out;

import java.util.Optional;
import com.tt.iam_core.domain.model.Usuario;
import com.tt.iam_core.domain.model.UsuarioId;

public interface UsuarioRepository {

    Optional<Usuario> findById(UsuarioId id);

    void save(Usuario usuario);
}
