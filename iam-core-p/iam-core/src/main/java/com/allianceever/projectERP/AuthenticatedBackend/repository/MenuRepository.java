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

    @Query("SELECT DISTINCT m FROM Menu m JOIN m.permisos p WHERE p.id IN :permisoIds ORDER BY m.orden ASC")
    List<Menu> findByPermisoIds(@Param("permisoIds") Set<Long> permisoIds);
}
