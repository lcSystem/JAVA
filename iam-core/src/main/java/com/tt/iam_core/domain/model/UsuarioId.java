package com.tt.iam_core.domain.model;

import java.util.Objects;

public class UsuarioId {

    private final Long value;

    public UsuarioId(Long value) {
        this.value = Objects.requireNonNull(value);
    }

    public Long value() {
        return value;
    }
}
