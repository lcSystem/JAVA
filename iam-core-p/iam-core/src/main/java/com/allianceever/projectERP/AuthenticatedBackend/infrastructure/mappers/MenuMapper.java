package com.allianceever.projectERP.AuthenticatedBackend.infrastructure.mappers;

import com.allianceever.projectERP.AuthenticatedBackend.domain.model.Menu;
import java.util.HashSet;

public class MenuMapper {
    public static Menu toDomain(com.allianceever.projectERP.AuthenticatedBackend.models.Menu entity) {
        if (entity == null)
            return null;

        return new Menu(
                entity.getId(),
                entity.getNombre(),
                entity.getRuta(),
                entity.getIcono(),
                entity.getCodigo(),
                entity.getParentId(),
                new HashSet<>(),
                entity.getOrden(),
                entity.getEstado());
    }
}
