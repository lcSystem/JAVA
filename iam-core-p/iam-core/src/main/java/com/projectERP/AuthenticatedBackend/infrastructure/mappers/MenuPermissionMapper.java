package com.projectERP.AuthenticatedBackend.infrastructure.mappers;

import com.projectERP.AuthenticatedBackend.domain.model.MenuPermission;
import com.projectERP.AuthenticatedBackend.models.RoleMenuPermission;

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
