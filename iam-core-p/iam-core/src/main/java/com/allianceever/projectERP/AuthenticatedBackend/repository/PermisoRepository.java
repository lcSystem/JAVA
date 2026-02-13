package com.allianceever.projectERP.AuthenticatedBackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.allianceever.projectERP.AuthenticatedBackend.models.Permiso;

@Repository
public interface PermisoRepository extends JpaRepository<Permiso, Long> {
}
