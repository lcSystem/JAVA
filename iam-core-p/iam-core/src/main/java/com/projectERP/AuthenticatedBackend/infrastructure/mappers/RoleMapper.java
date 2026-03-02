package com.projectERP.AuthenticatedBackend.infrastructure.mappers;

import com.projectERP.AuthenticatedBackend.domain.model.Role;
import java.util.stream.Collectors;

public class RoleMapper {
    public static Role toDomain(com.projectERP.AuthenticatedBackend.models.Role entity) {
        if (entity == null)
            return null;
        return new Role(
                entity.getRoleId(),
                entity.getAuthority(),
                entity.getMenuPermissions().stream()
                        .map(MenuPermissionMapper::toDomain)
                        .collect(Collectors.toSet()));
    }
}
