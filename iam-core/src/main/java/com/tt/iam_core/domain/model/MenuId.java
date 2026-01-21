package com.tt.iam_core.domain.model;

import java.util.Objects;

public class MenuId {

    private final Integer value;

    public MenuId(Integer value) {
        this.value = Objects.requireNonNull(value);
    }

    public Integer value() {
        return value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof MenuId)) return false;
        MenuId menuId = (MenuId) o;
        return value.equals(menuId.value);
    }

    @Override
    public int hashCode() {
        return value.hashCode();
    }
}
