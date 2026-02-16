package com.allianceever.projectERP.AuthenticatedBackend.models;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO for the permission matrix UI — shows all menus and CRUD flags for a given
 * role.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PermissionMatrixDTO {

    private Integer roleId;
    private String roleName;
    private List<MenuPermissionEntry> permissions = new ArrayList<>();

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MenuPermissionEntry {
        private Long menuId;
        private Long parentId;
        private String menuNombre;
        private String menuCodigo;
        private boolean canRead;
        private boolean canCreate;
        private boolean canUpdate;
        private boolean canDelete;
    }
}
