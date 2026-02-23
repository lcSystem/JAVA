package com.allianceever.projectERP.AuthenticatedBackend.models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;

@Entity
@Table(name = "user_sessions", indexes = {
        @Index(name = "idx_user_id", columnList = "userId"),
        @Index(name = "idx_status", columnList = "status"),
        @Index(name = "idx_start_time", columnList = "startTime"),
        @Index(name = "idx_expires_at", columnList = "expiresAt"),
        @Index(name = "idx_token_hash", columnList = "tokenHash", unique = true)
})
@Getter
@Setter
public class UserSession {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private Integer userId;

    @Column(nullable = false)
    private String username;

    @Column(nullable = false)
    private LocalDateTime startTime;

    private LocalDateTime endTime;

    @Column(nullable = false)
    private LocalDateTime expiresAt;

    @Column(nullable = false, length = 64)
    private String tokenHash;

    private String ipAddress;

    private String deviceInfo;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private SessionStatus status;

    private String closedBy;

    private String closedReason;

    public UserSession() {
    }

    public UserSession(Integer userId, String username, LocalDateTime startTime, LocalDateTime expiresAt,
            String tokenHash, String ipAddress, String deviceInfo, SessionStatus status) {
        this.userId = userId;
        this.username = username;
        this.startTime = startTime;
        this.expiresAt = expiresAt;
        this.tokenHash = tokenHash;
        this.ipAddress = ipAddress;
        this.deviceInfo = deviceInfo;
        this.status = status;
    }
}
