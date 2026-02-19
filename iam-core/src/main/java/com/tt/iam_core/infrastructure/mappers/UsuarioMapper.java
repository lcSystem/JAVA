package com.tt.iam_core.infrastructure.mappers;

import com.tt.iam_core.domain.model.Usuario;
import com.tt.iam_core.domain.model.UsuarioId;
import com.tt.iam_core.infrastructure.entities.UsuarioEntity;
import java.util.stream.Collectors;

public class UsuarioMapper {
    public static Usuario toDomain(UsuarioEntity entity) {
        if (entity == null)
            return null;

        return new Usuario(
                new UsuarioId(entity.getId()),
                entity.getUsername(),
                entity.getPasswordHash(),
                OrganizacionMapper.toDomain(entity.getOrganizacion()),
                entity.getRoles().stream()
                        .map(RolMapper::toDomain)
                        .collect(Collectors.toSet()));
    }
}
