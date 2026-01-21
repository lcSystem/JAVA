package com.tt.iam_core.domain.model;

import java.util.Objects;

public class RolId {

    private final Integer value;

    public RolId(Integer value) {
        this.value = Objects.requireNonNull(value);
    }

    public Integer value() {
        return value;
    }
}
