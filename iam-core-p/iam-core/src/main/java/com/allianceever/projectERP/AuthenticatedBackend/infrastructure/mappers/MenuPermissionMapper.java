package com.allianceever.projectERP.AuthenticatedBackend.infrastructure.mappers;

import com.allianceever.projectERP.AuthenticatedBackend.domain.model.MenuPermission;
import com.allianceever.projectERP.AuthenticatedBackend.models.RoleMenuPermission;

public class MenuPermissionMapper {
    public static MenuPermission toDomain(RoleMenuPermission entity) {
        if (entity == null)
            return null;
        return new MenuPermission(
                entity.getId(),
                MenuMapper.toDomain(entity.getMenu()),
                entity.getCanRead(),
                entity.getCanCreate(),
                entity.getCanUpdate(),
                entity.getCanDelete());
    }
}
