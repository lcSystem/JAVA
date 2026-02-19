package com.tt.iam_core.infrastructure.mappers;

import com.tt.iam_core.domain.model.Permiso;
import com.tt.iam_core.domain.model.PermisoId;
import com.tt.iam_core.infrastructure.entities.PermisoEntity;

public class PermisoMapper {
    public static Permiso toDomain(PermisoEntity entity) {
        if (entity == null)
            return null;
        return new Permiso(new PermisoId(entity.getId()), entity.getAccion(), entity.getRecurso());
    }
}
