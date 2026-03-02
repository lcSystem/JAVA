package com.conversationalhub.application.services;

import com.conversationalhub.domain.entities.UserPreferences;
import com.conversationalhub.domain.ports.in.UserPreferencesUseCase;
import com.conversationalhub.domain.ports.out.UserPreferencesRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.CachePut;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserPreferencesService implements UserPreferencesUseCase {

    private final UserPreferencesRepositoryPort repositoryPort;

    @Override
    @Transactional
    @CachePut(value = "user_preferences", key = "#preferences.userId")
    public UserPreferences savePreferences(UserPreferences preferences) {
        return repositoryPort.save(preferences);
    }

    @Override
    @Cacheable(value = "user_preferences", key = "#userId")
    public UserPreferences getPreferences(String userId) {
        return repositoryPort.findByUserId(userId)
                .orElse(UserPreferences.builder()
                        .userId(userId)
                        .chatColor("indigo")
                        .isFloatingBubble(false)
                        .themeMode("light")
                        .build());
    }
}
