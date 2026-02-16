package com.allianceever.projectERP.AuthenticatedBackend.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.allianceever.projectERP.AuthenticatedBackend.models.AssignPermissionRequest;
import com.allianceever.projectERP.AuthenticatedBackend.models.Menu;
import com.allianceever.projectERP.AuthenticatedBackend.models.MenuTreeDTO;
import com.allianceever.projectERP.AuthenticatedBackend.models.PermissionMatrixDTO;
import com.allianceever.projectERP.AuthenticatedBackend.models.Role;
import com.allianceever.projectERP.AuthenticatedBackend.models.RoleMenuPermission;
import com.allianceever.projectERP.AuthenticatedBackend.repository.MenuRepository;
import com.allianceever.projectERP.AuthenticatedBackend.repository.RoleMenuPermissionRepository;
import com.allianceever.projectERP.AuthenticatedBackend.repository.RoleRepository;

/**
 * Central service for all permission-related operations.
 * Handles menu tree building, permission checks, and permission management.
 */
@Service
@Transactional(readOnly = true)
@SuppressWarnings("null")
public class PermissionService {

    private static final String ADMIN_ROLE = "ADMIN";

    @Autowired
    private RoleMenuPermissionRepository permissionRepository;

    @Autowired
    private MenuRepository menuRepository;

    @Autowired
    private RoleRepository roleRepository;

    // ========================================================
    // AUTHORIZATION CHECKS
    // ========================================================

    /**
     * Check if the given roles include ADMIN.
     */
    public boolean isAdmin(Set<String> roleNames) {
        return roleNames.contains(ADMIN_ROLE);
    }

    /**
     * Check if any of the given roles has a specific permission on a menu.
     * ADMIN always returns true.
     */
    public boolean hasPermission(Set<String> roleNames, Set<Integer> roleIds, String menuCodigo, String action) {
        // ADMIN bypass
        if (isAdmin(roleNames)) {
            return true;
        }

        List<RoleMenuPermission> perms = permissionRepository.findByMenuCodigoAndRoleIds(menuCodigo, roleIds);

        for (RoleMenuPermission perm : perms) {
            switch (action.toUpperCase()) {
                case "READ":
                    if (Boolean.TRUE.equals(perm.getCanRead()))
                        return true;
                    break;
                case "CREATE":
                    if (Boolean.TRUE.equals(perm.getCanCreate()))
                        return true;
                    break;
                case "UPDATE":
                    if (Boolean.TRUE.equals(perm.getCanUpdate()))
                        return true;
                    break;
                case "DELETE":
                    if (Boolean.TRUE.equals(perm.getCanDelete()))
                        return true;
                    break;
            }
        }

        return false;
    }

    // ========================================================
    // MENU TREE (for frontend sidebar)
    // ========================================================

    /**
     * Build the menu tree for a user based on their roles.
     * Only includes menus where the user has READ permission.
     * ADMIN gets all menus with full permissions.
     */
    public List<MenuTreeDTO> getUserMenuTree(Set<String> roleNames, Set<Integer> roleIds) {
        // Get all menus
        List<Menu> allMenus = menuRepository.findByEstadoTrueOrderByOrdenAsc();

        // Build a map of menu permissions (merged across all roles)
        Map<Long, MenuTreeDTO.PermissionsDTO> permMap;

        if (isAdmin(roleNames)) {
            // ADMIN: full access to everything
            permMap = new HashMap<>();
            for (Menu m : allMenus) {
                permMap.put(m.getId(), new MenuTreeDTO.PermissionsDTO(true, true, true, true));
            }
        } else {
            // Non-admin: query actual permissions
            List<RoleMenuPermission> userPerms = permissionRepository.findByRoleIds(roleIds);
            permMap = mergePermissions(userPerms);
        }

        // Build tree
        return buildTree(allMenus, permMap);
    }

    /**
     * Merge permissions across multiple roles (union — if ANY role grants it, it's
     * granted).
     */
    private Map<Long, MenuTreeDTO.PermissionsDTO> mergePermissions(List<RoleMenuPermission> perms) {
        Map<Long, MenuTreeDTO.PermissionsDTO> result = new HashMap<>();

        for (RoleMenuPermission perm : perms) {
            Long menuId = perm.getMenu().getId();
            MenuTreeDTO.PermissionsDTO existing = result.computeIfAbsent(
                    menuId, k -> new MenuTreeDTO.PermissionsDTO(false, false, false, false));

            // Union: if any role grants, it's granted
            if (Boolean.TRUE.equals(perm.getCanRead()))
                existing.setRead(true);
            if (Boolean.TRUE.equals(perm.getCanCreate()))
                existing.setCreate(true);
            if (Boolean.TRUE.equals(perm.getCanUpdate()))
                existing.setUpdate(true);
            if (Boolean.TRUE.equals(perm.getCanDelete()))
                existing.setDelete(true);
        }

        return result;
    }

    /**
     * Build hierarchical menu tree, filtering out menus without READ permission.
     * Parent groups are included only if they have at least one visible child.
     */
    private List<MenuTreeDTO> buildTree(List<Menu> allMenus, Map<Long, MenuTreeDTO.PermissionsDTO> permMap) {
        // Index menus by ID
        Map<Long, Menu> menuIndex = new HashMap<>();
        for (Menu m : allMenus) {
            menuIndex.put(m.getId(), m);
        }

        // Build DTOs for leaf menus that have READ permission
        Map<Long, MenuTreeDTO> dtoIndex = new HashMap<>();

        for (Menu m : allMenus) {
            MenuTreeDTO.PermissionsDTO perms = permMap.get(m.getId());
            boolean isLeaf = m.getCodigo() != null && m.getRuta() != null;

            if (isLeaf) {
                // Leaf must have READ permission
                if (perms != null && perms.isRead()) {
                    MenuTreeDTO dto = toDTO(m, perms);
                    dtoIndex.put(m.getId(), dto);
                }
            }
        }

        // Build parent groups — include only if they have visible children
        List<MenuTreeDTO> roots = new ArrayList<>();

        for (Menu m : allMenus) {
            if (m.getParent() == null) {
                // This is a root menu group
                MenuTreeDTO groupDTO = buildGroupDTO(m, allMenus, dtoIndex, permMap);
                if (groupDTO != null) {
                    roots.add(groupDTO);
                }
            }
        }

        return roots;
    }

    /**
     * Build a group (parent) menu DTO. Returns null if no children are visible.
     */
    private MenuTreeDTO buildGroupDTO(Menu parent, List<Menu> allMenus,
            Map<Long, MenuTreeDTO> leafDTOs, Map<Long, MenuTreeDTO.PermissionsDTO> permMap) {

        List<MenuTreeDTO> visibleChildren = new ArrayList<>();

        for (Menu m : allMenus) {
            if (m.getParent() != null && m.getParent().getId().equals(parent.getId())) {
                MenuTreeDTO childDTO = leafDTOs.get(m.getId());
                if (childDTO != null) {
                    visibleChildren.add(childDTO);
                }
            }
        }

        // If no visible children, this group is hidden
        // Exception: if the parent itself is a leaf (has ruta), check its own
        // permission
        if (parent.getRuta() != null && parent.getCodigo() != null) {
            MenuTreeDTO leafDTO = leafDTOs.get(parent.getId());
            if (leafDTO != null) {
                return leafDTO;
            }
        }

        if (visibleChildren.isEmpty()) {
            return null;
        }

        MenuTreeDTO groupDTO = new MenuTreeDTO();
        groupDTO.setId(parent.getId());
        groupDTO.setNombre(parent.getNombre());
        groupDTO.setRuta(parent.getRuta());
        groupDTO.setIcono(parent.getIcono());
        groupDTO.setCodigo(parent.getCodigo());
        groupDTO.setOrden(parent.getOrden());
        groupDTO.setPermissions(permMap.getOrDefault(parent.getId(),
                new MenuTreeDTO.PermissionsDTO(true, false, false, false)));
        groupDTO.setChildren(visibleChildren);

        return groupDTO;
    }

    private MenuTreeDTO toDTO(Menu menu, MenuTreeDTO.PermissionsDTO perms) {
        MenuTreeDTO dto = new MenuTreeDTO();
        dto.setId(menu.getId());
        dto.setNombre(menu.getNombre());
        dto.setRuta(menu.getRuta());
        dto.setIcono(menu.getIcono());
        dto.setCodigo(menu.getCodigo());
        dto.setOrden(menu.getOrden());
        dto.setPermissions(perms);
        dto.setChildren(new ArrayList<>());
        return dto;
    }

    // ========================================================
    // PERMISSION MANAGEMENT (admin UI)
    // ========================================================

    /**
     * Get the full permission matrix for a role.
     */
    public PermissionMatrixDTO getPermissionMatrix(Integer roleId) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new RuntimeException("Role not found: " + roleId));

        List<Menu> allLeafMenus = menuRepository.findByCodigoIsNotNullOrderByOrdenAsc();
        List<RoleMenuPermission> rolePerms = permissionRepository.findByRoleId(roleId);

        // Index existing permissions by menuId
        Map<Long, RoleMenuPermission> permIndex = new HashMap<>();
        for (RoleMenuPermission rmp : rolePerms) {
            permIndex.put(rmp.getMenu().getId(), rmp);
        }

        PermissionMatrixDTO matrix = new PermissionMatrixDTO();
        matrix.setRoleId(roleId);
        matrix.setRoleName(role.getAuthority());

        List<PermissionMatrixDTO.MenuPermissionEntry> entries = new ArrayList<>();
        for (Menu menu : allLeafMenus) {
            RoleMenuPermission rmp = permIndex.get(menu.getId());
            PermissionMatrixDTO.MenuPermissionEntry entry = new PermissionMatrixDTO.MenuPermissionEntry();
            entry.setMenuId(menu.getId());
            entry.setParentId(menu.getParent() != null ? menu.getParent().getId() : null);
            entry.setMenuNombre(menu.getNombre());
            entry.setMenuCodigo(menu.getCodigo());

            if (rmp != null) {
                entry.setCanRead(Boolean.TRUE.equals(rmp.getCanRead()));
                entry.setCanCreate(Boolean.TRUE.equals(rmp.getCanCreate()));
                entry.setCanUpdate(Boolean.TRUE.equals(rmp.getCanUpdate()));
                entry.setCanDelete(Boolean.TRUE.equals(rmp.getCanDelete()));
            }

            entries.add(entry);
        }

        matrix.setPermissions(entries);
        return matrix;
    }

    /**
     * Assign permissions to a role. Replaces all existing permissions for that
     * role.
     * Cannot modify ADMIN role permissions.
     */
    @Transactional
    public PermissionMatrixDTO assignPermissions(Integer roleId, AssignPermissionRequest request) {
        Role role = roleRepository.findById(roleId)
                .orElseThrow(() -> new RuntimeException("Role not found: " + roleId));

        if (ADMIN_ROLE.equals(role.getAuthority())) {
            throw new RuntimeException("Cannot modify ADMIN role permissions — ADMIN has automatic full access");
        }

        // Delete existing permissions for this role
        permissionRepository.deleteByRoleRoleId(roleId);

        // Insert new permissions
        for (AssignPermissionRequest.PermissionEntry entry : request.getPermissions()) {
            // Skip entries where everything is false
            if (!entry.isCanRead() && !entry.isCanCreate() && !entry.isCanUpdate() && !entry.isCanDelete()) {
                continue;
            }

            Menu menu = menuRepository.findById(entry.getMenuId())
                    .orElseThrow(() -> new RuntimeException("Menu not found: " + entry.getMenuId()));

            RoleMenuPermission rmp = new RoleMenuPermission();
            rmp.setRole(role);
            rmp.setMenu(menu);
            rmp.setCanRead(entry.isCanRead());
            rmp.setCanCreate(entry.isCanCreate());
            rmp.setCanUpdate(entry.isCanUpdate());
            rmp.setCanDelete(entry.isCanDelete());

            permissionRepository.save(rmp);
        }

        return getPermissionMatrix(roleId);
    }
}
