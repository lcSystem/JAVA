package com.tt.iam_core.infrastructure.mappers;

import com.tt.iam_core.domain.model.Rol;
import com.tt.iam_core.domain.model.RolId;
import com.tt.iam_core.infrastructure.entities.RolEntity;
import java.util.stream.Collectors;

public class RolMapper {
    public static Rol toDomain(RolEntity entity) {
        if (entity == null)
            return null;
        return new Rol(
                new RolId(entity.getId()),
                entity.getNombre(),
                entity.getPermisos().stream()
                        .map(PermisoMapper::toDomain)
                        .collect(Collectors.toSet()));
    }
}
