package com.allianceever.projectERP.AuthenticatedBackend.infrastructure.adapters;

import com.allianceever.projectERP.AuthenticatedBackend.domain.model.Menu;
import com.allianceever.projectERP.AuthenticatedBackend.domain.ports.out.MenuRepositoryPort;
import com.allianceever.projectERP.AuthenticatedBackend.infrastructure.mappers.MenuMapper;
import com.allianceever.projectERP.AuthenticatedBackend.repository.MenuRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
public class MenuRepositoryAdapter implements MenuRepositoryPort {

    private final MenuRepository menuRepository;

    public MenuRepositoryAdapter(MenuRepository menuRepository) {
        this.menuRepository = menuRepository;
    }

    @Override
    public Optional<Menu> findById(Long id) {
        return menuRepository.findById(id).map(MenuMapper::toDomain);
    }

    @Override
    public List<Menu> findAll() {
        return menuRepository.findAll().stream()
                .map(MenuMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Menu save(Menu menu) {
        return menu;
    }

    @Override
    public void deleteById(Long id) {
        menuRepository.deleteById(id);
    }
}
