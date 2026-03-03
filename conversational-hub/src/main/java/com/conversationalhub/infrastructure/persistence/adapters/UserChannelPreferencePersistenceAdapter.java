package com.conversationalhub.infrastructure.persistence.adapters;

import com.conversationalhub.domain.entities.UserChannelPreference;
import com.conversationalhub.domain.ports.out.UserChannelPreferenceRepositoryPort;
import com.conversationalhub.infrastructure.persistence.entities.UserChannelPreferenceEntity;
import com.conversationalhub.infrastructure.persistence.repositories.JpaUserChannelPreferenceRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class UserChannelPreferencePersistenceAdapter implements UserChannelPreferenceRepositoryPort {

    private final JpaUserChannelPreferenceRepository repository;

    @Override
    public UserChannelPreference save(UserChannelPreference preference) {
        UserChannelPreferenceEntity entity = UserChannelPreferenceEntity.builder()
                .userId(preference.getUserId())
                .channelId(preference.getChannelId())
                .isPinned(preference.isPinned())
                .isArchived(preference.isArchived())
                .build();
        UserChannelPreferenceEntity saved = repository.save(entity);
        return mapToDomain(saved);
    }

    @Override
    public Optional<UserChannelPreference> findByUserIdAndChannelId(String userId, String channelId) {
        return repository.findById(new UserChannelPreferenceEntity.UserChannelPreferenceId(userId, channelId))
                .map(this::mapToDomain);
    }

    @Override
    public List<UserChannelPreference> findByUserId(String userId) {
        return repository.findByUserId(userId).stream()
                .map(this::mapToDomain)
                .collect(Collectors.toList());
    }

    private UserChannelPreference mapToDomain(UserChannelPreferenceEntity entity) {
        return UserChannelPreference.builder()
                .userId(entity.getUserId())
                .channelId(entity.getChannelId())
                .isPinned(entity.isPinned())
                .isArchived(entity.isArchived())
                .build();
    }
}
