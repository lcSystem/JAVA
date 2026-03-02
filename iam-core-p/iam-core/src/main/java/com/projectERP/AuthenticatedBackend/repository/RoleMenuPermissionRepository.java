package com.projectERP.AuthenticatedBackend.repository;

import java.util.List;
import java.util.Optional;
import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.projectERP.AuthenticatedBackend.models.RoleMenuPermission;

@Repository
public interface RoleMenuPermissionRepository extends JpaRepository<RoleMenuPermission, Long> {

    /**
     * Get all permissions for a set of roles (e.g., all roles a user has).
     */
    @Query("SELECT rmp FROM RoleMenuPermission rmp " +
            "JOIN FETCH rmp.menu m " +
            "WHERE rmp.role.roleId IN :roleIds")
    List<RoleMenuPermission> findByRoleIds(@Param("roleIds") Set<Integer> roleIds);

    /**
     * Get all permissions for a specific role.
     */
    @Query("SELECT rmp FROM RoleMenuPermission rmp " +
            "JOIN FETCH rmp.menu m " +
            "WHERE rmp.role.roleId = :roleId")
    List<RoleMenuPermission> findByRoleId(@Param("roleId") Integer roleId);

    /**
     * Check if any of the given roles has a specific permission on a menu.
     */
    @Query("SELECT rmp FROM RoleMenuPermission rmp " +
            "WHERE rmp.menu.codigo = :menuCodigo " +
            "AND rmp.role.roleId IN :roleIds")
    List<RoleMenuPermission> findByMenuCodigoAndRoleIds(
            @Param("menuCodigo") String menuCodigo,
            @Param("roleIds") Set<Integer> roleIds);

    /**
     * Find a specific role-menu permission entry.
     */
    Optional<RoleMenuPermission> findByRoleRoleIdAndMenuId(Integer roleId, Long menuId);

    /**
     * Delete all permissions for a role (before re-assigning).
     */
    void deleteByRoleRoleId(Integer roleId);
}
