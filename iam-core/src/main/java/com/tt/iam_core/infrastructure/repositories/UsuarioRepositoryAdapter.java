package com.tt.iam_core.infrastructure.repositories;

import com.tt.iam_core.domain.model.Usuario;
import com.tt.iam_core.domain.model.UsuarioId;
import com.tt.iam_core.domain.ports.out.UsuarioRepository;
import com.tt.iam_core.infrastructure.mappers.UsuarioMapper;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
public class UsuarioRepositoryAdapter implements UsuarioRepository {

    private final UsuarioJpaRepository jpaRepository;

    public UsuarioRepositoryAdapter(UsuarioJpaRepository jpaRepository) {
        this.jpaRepository = jpaRepository;
    }

    @Override
    public Optional<Usuario> findById(UsuarioId id) {
        Long idValue = id.value();
        if (idValue == null)
            return Optional.empty();
        return jpaRepository.findById(idValue)
                .map(UsuarioMapper::toDomain);
    }

    @Override
    public void save(Usuario usuario) {
        // Placeholder as per previous implementation
    }
}
