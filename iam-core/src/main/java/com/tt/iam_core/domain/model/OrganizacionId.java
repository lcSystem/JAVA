package com.tt.iam_core.domain.model;

import java.util.Objects;

public class OrganizacionId {

    private final Integer value;

    public OrganizacionId(Integer value) {
        this.value = Objects.requireNonNull(value);
    }

    public Integer value() {
        return value;
    }
}
