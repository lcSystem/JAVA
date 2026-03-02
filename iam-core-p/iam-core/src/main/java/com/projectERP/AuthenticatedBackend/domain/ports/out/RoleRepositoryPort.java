package com.projectERP.AuthenticatedBackend.domain.ports.out;

import com.projectERP.AuthenticatedBackend.domain.model.Role;
import java.util.Optional;
import java.util.Set;

public interface RoleRepositoryPort {
    Optional<Role> findById(Integer id);

    Optional<Role> findByName(String name);

    Set<Role> findAll();

    Role save(Role role);
}
