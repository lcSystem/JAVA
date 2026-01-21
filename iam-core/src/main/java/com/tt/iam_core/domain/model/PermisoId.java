package com.tt.iam_core.domain.model;

import java.util.Objects;

public class PermisoId {

    private final Integer value;

    public PermisoId(Integer value) {
        this.value = Objects.requireNonNull(value);
    }

    public Integer value() {
        return value;
    }
}
