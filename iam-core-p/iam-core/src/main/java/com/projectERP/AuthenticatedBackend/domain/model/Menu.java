package com.allianceever.projectERP.AuthenticatedBackend.domain.model;

import java.util.Set;

public class Menu {
    private final Long id;
    private final String name;
    private final String route;
    private final String icon;
    private final String code;
    private final Long parentId;
    private final Set<Menu> children;
    private final Integer order;
    private final boolean active;

    public Menu(Long id, String name, String route, String icon, String code,
            Long parentId, Set<Menu> children, Integer order, boolean active) {
        this.id = id;
        this.name = name;
        this.route = route;
        this.icon = icon;
        this.code = code;
        this.parentId = parentId;
        this.children = children;
        this.order = order;
        this.active = active;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getRoute() {
        return route;
    }

    public String getIcon() {
        return icon;
    }

    public String getCode() {
        return code;
    }

    public Long getParentId() {
        return parentId;
    }

    public Set<Menu> getChildren() {
        return children;
    }

    public Integer getOrder() {
        return order;
    }

    public boolean isActive() {
        return active;
    }
}
