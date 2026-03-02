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
        // Marcamos como online con un TTL de 5 minutos por si acaso el disconnect no se
        // dispara
        redisTemplate.opsForValue().set(PRESENCE_KEY_PREFIX + userId, "online",
                java.util.Objects.requireNonNull(java.time.Duration.ofMinutes(5)));
    }

    public void markAsOffline(String userId) {
        redisTemplate.delete(PRESENCE_KEY_PREFIX + userId);
    }

    public boolean isOnline(String userId) {
        return Boolean.TRUE.equals(redisTemplate.hasKey(PRESENCE_KEY_PREFIX + userId));
    }

    public Set<String> getOnlineUsers() {
        Set<String> keys = redisTemplate.keys(PRESENCE_KEY_PREFIX + "*");
        if (keys == null)
            return Set.of();
        return keys.stream()
                .map(key -> key.replace(PRESENCE_KEY_PREFIX, ""))
                .collect(Collectors.toSet());
    }
}
