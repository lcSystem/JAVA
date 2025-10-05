package com.tt.iam_core.infrastructure.repositories;

import com.tt.iam_core.infrastructure.entities.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository; // 🔹 IMPORT REQUERIDO

import java.util.Optional;

@Repository
public interface Usuario extends JpaRepository<Usuario, Integer> {
    Optional<Usuario> findByUsername(String username);
}
