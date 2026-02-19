package com.allianceever.projectERP.AuthenticatedBackend.domain.model;

import java.util.Set;

public class Role {
    private final Integer id;
    private final String name;
    private final Set<MenuPermission> menuPermissions;

    public Role(Integer id, String name, Set<MenuPermission> menuPermissions) {
        this.id = id;
        this.name = name;
        this.menuPermissions = menuPermissions;
    }

    public Integer getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public Set<MenuPermission> getMenuPermissions() {
        return menuPermissions;
    }
}
