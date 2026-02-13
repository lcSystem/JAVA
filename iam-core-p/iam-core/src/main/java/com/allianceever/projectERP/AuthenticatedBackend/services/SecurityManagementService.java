package com.allianceever.projectERP.AuthenticatedBackend.services;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.allianceever.projectERP.AuthenticatedBackend.models.ApplicationUser;
import com.allianceever.projectERP.AuthenticatedBackend.models.Menu;
import com.allianceever.projectERP.AuthenticatedBackend.models.Permiso;
import com.allianceever.projectERP.AuthenticatedBackend.models.Role;
import com.allianceever.projectERP.AuthenticatedBackend.repository.MenuRepository;
import com.allianceever.projectERP.AuthenticatedBackend.repository.PermisoRepository;
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
    private PermisoRepository permisoRepository;

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
        // Implementation might need to be more specific based on requirements (e.g.,
        // partial updates)
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
        role.setPermisos(roleDetails.getPermisos());
        return roleRepository.save(role);
    }

    public void deleteRole(Integer id) {
        roleRepository.deleteById(id);
    }

    // --- Permisos ---
    public List<Permiso> getAllPermisos() {
        return permisoRepository.findAll();
    }

    public Permiso createPermiso(Permiso permiso) {
        return permisoRepository.save(permiso);
    }

    public Permiso updatePermiso(Long id, Permiso permisoDetails) {
        Permiso permiso = permisoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Permission not found"));
        permiso.setAccion(permisoDetails.getAccion());
        permiso.setRecurso(permisoDetails.getRecurso());
        permiso.setDescripcion(permisoDetails.getDescripcion());
        return permisoRepository.save(permiso);
    }

    public void deletePermiso(Long id) {
        permisoRepository.deleteById(id);
    }

    // --- Menus ---
    public List<Menu> getAllMenus() {
        return menuRepository.findAll();
    }

    public List<Menu> getRootMenus() {
        return menuRepository.findByParentIsNullOrderByOrdenAsc();
    }

    public Menu createMenu(Menu menu) {
        return menuRepository.save(menu);
    }

    public Menu updateMenu(Long id, Menu menuDetails) {
        Menu menu = menuRepository.findById(id).orElseThrow(() -> new RuntimeException("Menu not found"));
        menu.setNombre(menuDetails.getNombre());
        menu.setRuta(menuDetails.getRuta());
        menu.setIcono(menuDetails.getIcono());
        menu.setOrden(menuDetails.getOrden());
        menu.setEstado(menuDetails.getEstado());
        menu.setParent(menuDetails.getParent());
        menu.setPermisos(menuDetails.getPermisos());
        return menuRepository.save(menu);
    }

    public void deleteMenu(Long id) {
        menuRepository.deleteById(id);
    }

    // --- User Menus (based on role permissions) ---
    public List<Menu> getUserMenus(Long userId) {
        ApplicationUser user = userRepository.findById(userId.intValue())
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Collect all permission IDs from the user's roles
        Set<Long> permisoIds = new java.util.HashSet<>();
        for (var authority : user.getAuthorities()) {
            if (authority instanceof Role) {
                Role role = (Role) authority;
                for (Permiso p : role.getPermisos()) {
                    permisoIds.add(p.getId());
                }
            }
        }

        if (permisoIds.isEmpty()) {
            return List.of();
        }

        return menuRepository.findByPermisoIds(permisoIds);
    }
}
