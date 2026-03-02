package com.projectERP.AuthenticatedBackend.domain.ports.out;

import com.projectERP.AuthenticatedBackend.domain.model.User;
import java.util.Optional;

public interface UserRepositoryPort {
    Optional<User> findById(Integer id);

    Optional<User> findByUsername(String username);

    User save(User user);

    void deleteById(Integer id);

    boolean existsByUsername(String username);
}
