package com.allianceever.projectERP.AuthenticatedBackend.controllers;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.allianceever.projectERP.AuthenticatedBackend.models.ApplicationUser;
import com.allianceever.projectERP.AuthenticatedBackend.models.AssignPermissionRequest;
import com.allianceever.projectERP.AuthenticatedBackend.models.Menu;
import com.allianceever.projectERP.AuthenticatedBackend.models.MenuOrderDTO;
import com.allianceever.projectERP.AuthenticatedBackend.models.MenuTreeDTO;
import com.allianceever.projectERP.AuthenticatedBackend.models.PermissionMatrixDTO;
import com.allianceever.projectERP.AuthenticatedBackend.models.Role;
import com.allianceever.projectERP.AuthenticatedBackend.repository.RoleRepository;
import com.allianceever.projectERP.AuthenticatedBackend.services.PermissionService;
import com.allianceever.projectERP.AuthenticatedBackend.services.SecurityManagementService;

@CrossOrigin(origins = "*")
@RestController
@RequestMapping("/api/security")
public class SecurityManagementController {

    @Autowired
    private SecurityManagementService securityService;

    @Autowired
    private PermissionService permissionService;

    @Autowired
    private RoleRepository roleRepository;

    // ============================
    // Users
    // ============================
    @GetMapping("/users")
    public List<ApplicationUser> getAllUsers() {
        return securityService.getAllUsers();
    }

    @PostMapping("/users")
    public ApplicationUser createUser(@RequestBody ApplicationUser user, @AuthenticationPrincipal Jwt jwt) {
        checkPermission(jwt, "USERS", "CREATE");
        return securityService.createUser(user);
    }

    @PutMapping("/users/{id}")
    public ApplicationUser updateUser(@PathVariable Long id, @RequestBody ApplicationUser user,
            @AuthenticationPrincipal Jwt jwt) {
        checkPermission(jwt, "USERS", "UPDATE");
        return securityService.updateUser(id, user);
    }

    @DeleteMapping("/users/{id}")
    public ResponseEntity<?> deleteUser(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        checkPermission(jwt, "USERS", "DELETE");
        securityService.deleteUser(id);
        return ResponseEntity.ok().build();
    }

    // ============================
    // Roles
    // ============================
    @GetMapping("/roles")
    public List<Role> getAllRoles() {
        return securityService.getAllRoles();
    }

    @PostMapping("/roles")
    public Role createRole(@RequestBody Role role, @AuthenticationPrincipal Jwt jwt) {
        checkPermission(jwt, "ROLES", "CREATE");
        return securityService.createRole(role);
    }

    @PutMapping("/roles/{id}")
    public Role updateRole(@PathVariable Integer id, @RequestBody Role role, @AuthenticationPrincipal Jwt jwt) {
        checkPermission(jwt, "ROLES", "UPDATE");
        return securityService.updateRole(id, role);
    }

    @DeleteMapping("/roles/{id}")
    public ResponseEntity<?> deleteRole(@PathVariable Integer id, @AuthenticationPrincipal Jwt jwt) {
        checkPermission(jwt, "ROLES", "DELETE");
        securityService.deleteRole(id);
        return ResponseEntity.ok().build();
    }

    // ============================
    // Menus (admin management)
    // ============================
    @GetMapping("/menus")
    public List<Menu> getAllMenus() {
        return securityService.getAllMenus();
    }

    @GetMapping("/menus/root")
    public List<Menu> getRootMenus() {
        return securityService.getRootMenus();
    }

    @PostMapping("/menus")
    public Menu createMenu(@RequestBody Menu menu, @AuthenticationPrincipal Jwt jwt) {
        // For menus, we check permission on the "MENUS" resource itself
        checkPermission(jwt, "MENUS", "CREATE");
        return securityService.createMenu(menu);
    }

    @PutMapping("/menus/{id}")
    public Menu updateMenu(@PathVariable Long id, @RequestBody Menu menu, @AuthenticationPrincipal Jwt jwt) {
        checkPermission(jwt, "MENUS", "UPDATE");
        return securityService.updateMenu(id, menu);
    }

    @DeleteMapping("/menus/{id}")
    public ResponseEntity<?> deleteMenu(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        checkPermission(jwt, "MENUS", "DELETE");
        securityService.deleteMenu(id);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/menus/reorder")
    public ResponseEntity<?> reorderMenus(@RequestBody List<MenuOrderDTO> orders, @AuthenticationPrincipal Jwt jwt) {
        checkPermission(jwt, "MENUS", "UPDATE");
        securityService.updateMenuOrder(orders);
        return ResponseEntity.ok().build();
    }

    // ============================
    // Permissions (RBAC management)
    // ============================

    /**
     * Get the permission matrix for a specific role.
     * Shows all menus and their CRUD flags for that role.
     */
    @GetMapping("/roles/{roleId}/permissions")
    public PermissionMatrixDTO getRolePermissions(@PathVariable Integer roleId) {
        return permissionService.getPermissionMatrix(roleId);
    }

    /**
     * Assign permissions to a role.
     * Replaces all existing permissions for that role.
     * ADMIN role cannot be modified.
     */
    @PutMapping("/roles/{roleId}/permissions")
    public PermissionMatrixDTO assignRolePermissions(
            @PathVariable Integer roleId,
            @RequestBody AssignPermissionRequest request) {
        return permissionService.assignPermissions(roleId, request);
    }

    // ============================
    // Current User Menus (filtered by permissions)
    // ============================

    /**
     * Get the menu tree for the currently authenticated user.
     * Only includes menus where the user has READ permission.
     * Returns hierarchical structure with CRUD permissions per menu.
     */
    @GetMapping("/my/menus")
    public List<MenuTreeDTO> getMyMenus(@AuthenticationPrincipal Jwt jwt) {
        Set<String> roleNames = extractRoleNames(jwt);
        Set<Integer> roleIds = resolveRoleIds(roleNames);
        return permissionService.getUserMenuTree(roleNames, roleIds);
    }

    /**
     * Get the menu tree for a specific user (admin use).
     */
    @GetMapping("/users/{userId}/menus")
    public List<MenuTreeDTO> getUserMenus(@PathVariable Long userId) {
        // Get user's roles
        ApplicationUser user = securityService.getAllUsers().stream()
                .filter(u -> u.getUserId().longValue() == userId)
                .findFirst()
                .orElseThrow(() -> new RuntimeException("User not found"));

        Set<String> roleNames = new HashSet<>();
        Set<Integer> roleIds = new HashSet<>();
        user.getAuthorities().forEach(auth -> {
            if (auth instanceof Role) {
                Role role = (Role) auth;
                roleNames.add(role.getAuthority());
                roleIds.add(role.getRoleId());
            }
        });

        return permissionService.getUserMenuTree(roleNames, roleIds);
    }

    // ============================
    // Helpers
    // ============================

    private void checkPermission(Jwt jwt, String menuCodigo, String action) {
        Set<String> roleNames = extractRoleNames(jwt);
        Set<Integer> roleIds = resolveRoleIds(roleNames);
        if (!permissionService.hasPermission(roleNames, roleIds, menuCodigo, action)) {
            throw new RuntimeException("Access Denied: You do not have permission to " + action + " " + menuCodigo);
        }
    }

    private Set<String> extractRoleNames(Jwt jwt) {
        Set<String> roleNames = new HashSet<>();
        String rolesStr = jwt.getClaimAsString("roles");
        if (rolesStr != null) {
            for (String role : rolesStr.split(" ")) {
                String clean = role.trim();
                if (!clean.isEmpty()) {
                    roleNames.add(clean);
                }
            }
        }
        return roleNames;
    }

    private Set<Integer> resolveRoleIds(Set<String> roleNames) {
        Set<Integer> roleIds = new HashSet<>();
        for (String name : roleNames) {
            roleRepository.findByAuthority(name)
                    .ifPresent(role -> roleIds.add(role.getRoleId()));
        }
        return roleIds;
    }
}
