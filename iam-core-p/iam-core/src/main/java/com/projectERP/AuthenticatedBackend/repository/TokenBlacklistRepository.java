package com.projectERP.AuthenticatedBackend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.projectERP.AuthenticatedBackend.models.BlacklistedToken;


public interface TokenBlacklistRepository extends JpaRepository<BlacklistedToken, Long> {
    boolean existsByToken(String token);
}
