package com.clientauth.repository;

import com.clientauth.entity.ClientRefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.Optional;

@Repository
public interface RefreshTokenRepository extends JpaRepository<ClientRefreshToken, Long> {

    Optional<ClientRefreshToken> findByTokenAndRevokedFalse(String token);

    @Modifying
    @Query("UPDATE ClientRefreshToken t SET t.revoked = true WHERE t.customerId = :customerId")
    void revokeAllByCustomerId(Long customerId);

    @Modifying
    @Query("DELETE FROM ClientRefreshToken t WHERE t.expiresAt < :now OR t.revoked = true")
    void deleteExpiredAndRevoked(LocalDateTime now);
}
