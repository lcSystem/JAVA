package com.projectERP.AuthenticatedBackend.domain.model;

public record MenuPermission(
        Long id,
        Menu menu,
        boolean canRead,
        boolean canCreate,
        boolean canUpdate,
        boolean canDelete) {
}
