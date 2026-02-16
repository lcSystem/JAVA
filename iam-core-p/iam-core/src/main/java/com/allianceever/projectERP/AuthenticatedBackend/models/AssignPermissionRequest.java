package com.allianceever.projectERP.AuthenticatedBackend.models;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request body for assigning permissions to a role.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AssignPermissionRequest {

    private List<PermissionEntry> permissions;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PermissionEntry {
        private Long menuId;
        private boolean canRead;
        private boolean canCreate;
        private boolean canUpdate;
        private boolean canDelete;
    }
}
