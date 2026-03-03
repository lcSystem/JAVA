package com.projectERP.AuthenticatedBackend.repository;

import com.projectERP.AuthenticatedBackend.models.SessionStatus;
import com.projectERP.AuthenticatedBackend.models.UserSession;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserSessionRepository extends JpaRepository<UserSession, Long> {

    Optional<UserSession> findByTokenHash(String tokenHash);

    Page<UserSession> findAllByStatus(SessionStatus status, Pageable pageable);

    Page<UserSession> findAllByUserId(Integer userId, Pageable pageable);

    Optional<UserSession> findByUserIdAndDeviceInfoAndStatus(Integer userId, String deviceInfo, SessionStatus status);

    @Query("SELECT s FROM UserSession s WHERE s.userId = :userId AND s.status = 'ACTIVE' ORDER BY s.startTime ASC")
    List<UserSession> findActiveSessionsByUserId(@Param("userId") Integer userId);

    @Query("SELECT s FROM UserSession s WHERE s.status = 'ACTIVE' AND s.expiresAt < :now")
    List<UserSession> findExpiredSessions(@Param("now") LocalDateTime now);

    @Query("DELETE FROM UserSession s WHERE s.status IN ('CLOSED', 'EXPIRED', 'REVOKED') AND s.startTime < :threshold")
    void deleteOldSessions(@Param("threshold") LocalDateTime threshold);

    Optional<UserSession> findFirstByIpAddressAndLatitudeIsNotNullOrderByStartTimeDesc(String ipAddress);
}
