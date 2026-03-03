package com.conversationalhub.application.services;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PresenceService {
    private final StringRedisTemplate redisTemplate;
    private static final String PRESENCE_KEY_PREFIX = "presence:user:";

    public void markAsOnline(String userId) {
        try {
            redisTemplate.opsForValue().set(PRESENCE_KEY_PREFIX + userId, "online",
                    java.util.Objects.requireNonNull(java.time.Duration.ofMinutes(5)));
        } catch (Exception e) {
            System.err.println("[PresenceService] Error marking as online: " + e.getMessage());
        }
    }

    public void markAsOffline(String userId) {
        try {
            redisTemplate.delete(PRESENCE_KEY_PREFIX + userId);
        } catch (Exception e) {
            System.err.println("[PresenceService] Error marking as offline: " + e.getMessage());
        }
    }

    public boolean isOnline(String userId) {
        try {
            return Boolean.TRUE.equals(redisTemplate.hasKey(PRESENCE_KEY_PREFIX + userId));
        } catch (Exception e) {
            return false;
        }
    }

    public Set<String> getOnlineUsers() {
        try {
            Set<String> keys = redisTemplate.keys(PRESENCE_KEY_PREFIX + "*");
            if (keys == null)
                return Set.of();
            return keys.stream()
                    .map(key -> key.replace(PRESENCE_KEY_PREFIX, ""))
                    .collect(Collectors.toSet());
        } catch (Exception e) {
            System.err.println("[PresenceService] Redis is down, returning empty online set.");
            return Set.of();
        }
    }
}
