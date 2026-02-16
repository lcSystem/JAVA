package com.allianceever.projectERP.AuthenticatedBackend.repository;

import java.util.List;
import java.util.Set;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.allianceever.projectERP.AuthenticatedBackend.models.Menu;

@Repository
public interface MenuRepository extends JpaRepository<Menu, Long> {

    List<Menu> findByParentIsNullOrderByOrdenAsc();

    /**
     * Find all leaf menus where at least one of the given roles has can_read =
     * true.
     */
    @Query("SELECT DISTINCT m FROM Menu m " +
            "JOIN RoleMenuPermission rmp ON rmp.menu = m " +
            "WHERE rmp.role.roleId IN :roleIds AND rmp.canRead = true " +
            "ORDER BY m.orden ASC")
    List<Menu> findReadableMenusByRoleIds(@Param("roleIds") Set<Integer> roleIds);

    /**
     * Find all active menus ordered for tree building.
     */
    List<Menu> findByEstadoTrueOrderByOrdenAsc();

    /**
     * Find all leaf menus (menus with codigo set — these are the actionable ones).
     */
    List<Menu> findByCodigoIsNotNullOrderByOrdenAsc();
}
