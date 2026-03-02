package com.conversationalhub.infrastructure.persistence.adapters;

import com.conversationalhub.domain.entities.UserPreferences;
import com.conversationalhub.domain.ports.out.UserPreferencesRepositoryPort;
import com.conversationalhub.infrastructure.persistence.entities.UserPreferencesEntity;
import com.conversationalhub.infrastructure.persistence.repositories.JpaUserPreferencesRepository;
import com.conversationalhub.infrastructure.persistence.mappers.UserPreferencesMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@RequiredArgsConstructor
public class UserPreferencesPersistenceAdapter implements UserPreferencesRepositoryPort {

    private final JpaUserPreferencesRepository jpaRepository;
    private final UserPreferencesMapper userPreferencesMapper;

    @Override
    public UserPreferences save(UserPreferences preferences) {
        UserPreferencesEntity entity = userPreferencesMapper.toEntity(preferences);
        UserPreferencesEntity savedEntity = jpaRepository.save(entity);
        return userPreferencesMapper.toDomain(savedEntity);
    }

    @Override
    public Optional<UserPreferences> findByUserId(String userId) {
        return jpaRepository.findById(userId)
                .map(userPreferencesMapper::toDomain);
    }
}
