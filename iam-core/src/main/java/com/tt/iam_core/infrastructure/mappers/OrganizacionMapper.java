package com.tt.iam_core.infrastructure.mappers;

import com.tt.iam_core.domain.model.Organizacion;
import com.tt.iam_core.domain.model.OrganizacionId;
import com.tt.iam_core.infrastructure.entities.OrganizacionEntity;

public class OrganizacionMapper {
    public static Organizacion toDomain(OrganizacionEntity entity) {
        if (entity == null)
            return null;
        return new Organizacion(new OrganizacionId(entity.getId()), entity.getNombre());
    }
}
