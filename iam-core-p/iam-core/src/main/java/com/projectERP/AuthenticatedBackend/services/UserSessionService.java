package com.projectERP.AuthenticatedBackend.services;

import com.projectERP.AuthenticatedBackend.models.BlacklistedToken;
import com.projectERP.AuthenticatedBackend.models.SessionStatus;
import com.projectERP.AuthenticatedBackend.models.UserSession;
import com.projectERP.AuthenticatedBackend.repository.TokenBlacklistRepository;
import com.projectERP.AuthenticatedBackend.repository.UserSessionRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;

@Service
@Transactional
public class UserSessionService {

    @Autowired
    private UserSessionRepository sessionRepository;

    @Autowired
    private TokenBlacklistRepository blacklistRepository;

    @Value("${app.security.session-secret}")
    private String sessionSecret;

    @Value("${app.security.session-limit:5}")
    private int sessionLimit;

    public void createSession(Integer userId, String username, String token, HttpServletRequest request) {
        String ipAddress = request.getRemoteAddr();
        String userAgent = request.getHeader("User-Agent");
        String deviceInfo = normalizeUserAgent(userAgent);
        String tokenHash = hashToken(token);

        // Deduplicate: Close existing active session on the same device/browser
        sessionRepository.findByUserIdAndDeviceInfoAndStatus(userId, deviceInfo, SessionStatus.ACTIVE)
                .ifPresent(existing -> closeSession(existing.getId(), "SYSTEM", "REPLACED_BY_NEW_LOGIN"));

        // Limit active sessions
        List<UserSession> activeSessions = sessionRepository.findActiveSessionsByUserId(userId);
        if (activeSessions.size() >= sessionLimit) {
            UserSession oldest = activeSessions.get(0);
            closeSession(oldest.getId(), "SYSTEM", "SYSTEM_LIMIT");
        }

        // Token usually expires in 8 hours (matching TokenService)
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expiresAt = now.plusHours(8);

        UserSession session = new UserSession(userId, username, now, expiresAt, tokenHash, ipAddress, deviceInfo,
                SessionStatus.ACTIVE);
        sessionRepository.save(session);
    }

    public void closeSession(Long sessionId, String closedBy, String reason) {
        sessionRepository.findById(sessionId).ifPresent(session -> {
            if (session.getStatus() == SessionStatus.ACTIVE) {
                session.setStatus(reason.equals("REVOKED") ? SessionStatus.REVOKED : SessionStatus.CLOSED);
                session.setEndTime(LocalDateTime.now());
                session.setClosedBy(closedBy);
                session.setClosedReason(reason);
                sessionRepository.save(session);

                // Add hashed token to blacklist
                blacklistRepository.save(new BlacklistedToken(session.getTokenHash()));
            }
        });
    }

    public void closeSessionByToken(String token, String closedBy, String reason) {
        String tokenHash = hashToken(token);
        sessionRepository.findByTokenHash(tokenHash).ifPresent(session -> {
            closeSession(session.getId(), closedBy, reason);
        });
    }

    public Page<UserSession> getSessions(SessionStatus status, Pageable pageable) {
        if (status != null) {
            return sessionRepository.findAllByStatus(status, pageable);
        }
        return sessionRepository.findAll(pageable);
    }

    public String hashToken(String token) {
        try {
            Mac sha256_HMAC = Mac.getInstance("HmacSHA256");
            SecretKeySpec secret_key = new SecretKeySpec(sessionSecret.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            sha256_HMAC.init(secret_key);
            byte[] hash = sha256_HMAC.doFinal(token.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException("Error hashing token", e);
        }
    }

    @Scheduled(cron = "0 0 * * * *") // Every hour
    public void expireOldSessions() {
        LocalDateTime now = LocalDateTime.now();
        List<UserSession> expired = sessionRepository.findExpiredSessions(now);
        for (UserSession session : expired) {
            session.setStatus(SessionStatus.EXPIRED);
            session.setEndTime(session.getExpiresAt());
            session.setClosedBy("SYSTEM");
            session.setClosedReason("EXPIRED");
            sessionRepository.save(session);

            // Also blacklist expired tokens just in case they are still used
            blacklistRepository.save(new BlacklistedToken(session.getTokenHash()));
        }
    }

    @Scheduled(cron = "0 0 0 * * *") // Every day at midnight
    public void cleanupHistory() {
        LocalDateTime threshold = LocalDateTime.now().minusDays(90);
        sessionRepository.deleteOldSessions(threshold);
    }

    private String normalizeUserAgent(String userAgent) {
        if (userAgent == null)
            return "Unknown";

        String os = "Unknown OS";
        if (userAgent.contains("Windows"))
            os = "Windows";
        else if (userAgent.contains("Mac"))
            os = "Mac OS";
        else if (userAgent.contains("Linux"))
            os = "Linux";
        else if (userAgent.contains("Android"))
            os = "Android";
        else if (userAgent.contains("iPhone") || userAgent.contains("iPad"))
            os = "iOS";

        String browser = "Unknown Browser";
        if (userAgent.contains("Chrome"))
            browser = "Chrome";
        else if (userAgent.contains("Firefox"))
            browser = "Firefox";
        else if (userAgent.contains("Safari"))
            browser = "Safari";
        else if (userAgent.contains("Edge"))
            browser = "Edge";

        return browser + " on " + os;
    }
}
