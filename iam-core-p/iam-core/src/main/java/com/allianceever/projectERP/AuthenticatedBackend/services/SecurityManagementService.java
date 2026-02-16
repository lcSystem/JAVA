package com.allianceever.projectERP.AuthenticatedBackend.services;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.allianceever.projectERP.AuthenticatedBackend.models.ApplicationUser;
import com.allianceever.projectERP.AuthenticatedBackend.models.Menu;
import com.allianceever.projectERP.AuthenticatedBackend.models.Role;
import com.allianceever.projectERP.AuthenticatedBackend.repository.MenuRepository;
import com.allianceever.projectERP.AuthenticatedBackend.repository.RoleRepository;
import com.allianceever.projectERP.AuthenticatedBackend.repository.UserRepository;

@Service
@Transactional
@SuppressWarnings("null")
public class SecurityManagementService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private MenuRepository menuRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    // --- Users ---
    public List<ApplicationUser> getAllUsers() {
        return userRepository.findAll();
    }

    public ApplicationUser createUser(ApplicationUser user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    public ApplicationUser updateUser(Long id, ApplicationUser userDetails) {
        ApplicationUser user = userRepository.findById(id.intValue())
                .orElseThrow(() -> new RuntimeException("User not found"));
        user.setUsername(userDetails.getUsername());
        user.setEmail(userDetails.getEmail());
        user.setEstado(userDetails.getEstado());
        user.setOrganizacionId(userDetails.getOrganizacionId());
        user.setAuthorities((Set<Role>) (Set<?>) new java.util.HashSet<>(userDetails.getAuthorities()));
        if (userDetails.getPassword() != null && !userDetails.getPassword().isEmpty()) {
            user.setPassword(passwordEncoder.encode(userDetails.getPassword()));
        }
        return userRepository.save(user);
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id.intValue());
    }

    // --- Roles ---
    public List<Role> getAllRoles() {
        return roleRepository.findAll();
    }

    public Role createRole(Role role) {
        return roleRepository.save(role);
    }

    public Role updateRole(Integer id, Role roleDetails) {
        Role role = roleRepository.findById(id).orElseThrow(() -> new RuntimeException("Role not found"));
        role.setAuthority(roleDetails.getAuthority());
        return roleRepository.save(role);
    }

    public void deleteRole(Integer id) {
        roleRepository.deleteById(id);
    }

    // --- Menus ---
    public List<Menu> getAllMenus() {
        return menuRepository.findAll();
    }

    public List<Menu> getRootMenus() {
        return menuRepository.findByParentIsNullOrderByOrdenAsc();
    }

    public Menu createMenu(Menu menu) {
        if (menu.getParent() != null && menu.getParent().getId() != null) {
            Menu parent = menuRepository.findById(menu.getParent().getId())
                    .orElseThrow(() -> new RuntimeException("Parent menu not found"));
            menu.setParent(parent);
        } else {
            menu.setParent(null);
        }
        return menuRepository.save(menu);
    }

    public Menu updateMenu(Long id, Menu menuDetails) {
        Menu menu = menuRepository.findById(id).orElseThrow(() -> new RuntimeException("Menu not found"));
        menu.setNombre(menuDetails.getNombre());
        menu.setRuta(menuDetails.getRuta());
        menu.setIcono(menuDetails.getIcono());
        menu.setCodigo(menuDetails.getCodigo());
        menu.setOrden(menuDetails.getOrden());
        menu.setEstado(menuDetails.getEstado());

        if (menuDetails.getParent() != null && menuDetails.getParent().getId() != null) {
            if (menuDetails.getParent().getId().equals(id)) {
                throw new RuntimeException("Cannot set menu as its own parent");
            }
            Menu parent = menuRepository.findById(menuDetails.getParent().getId())
                    .orElseThrow(() -> new RuntimeException("Parent menu not found"));
            menu.setParent(parent);
        } else {
            menu.setParent(null);
        }

        return menuRepository.save(menu);
    }

    public void deleteMenu(Long id) {
        Menu menu = menuRepository.findById(id).orElseThrow(() -> new RuntimeException("Menu not found"));
        if (menu.getChildren() != null && !menu.getChildren().isEmpty()) {
            throw new RuntimeException(
                    "No se puede eliminar un menú que tiene submenús. Elimine o mueva los submenús primero.");
        }
        menuRepository.delete(menu);
    }
}
