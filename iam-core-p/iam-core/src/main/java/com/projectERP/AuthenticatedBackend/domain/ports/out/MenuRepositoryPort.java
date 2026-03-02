package com.projectERP.AuthenticatedBackend.domain.ports.out;

import com.projectERP.AuthenticatedBackend.domain.model.Menu;
import java.util.List;
import java.util.Optional;

public interface MenuRepositoryPort {
    Optional<Menu> findById(Long id);

    List<Menu> findAll();

    Menu save(Menu menu);

    void deleteById(Long id);
}
