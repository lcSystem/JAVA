package com.conversationalhub.application.services;

import com.conversationalhub.domain.entities.UserChannelPreference;
import com.conversationalhub.domain.ports.in.UserChannelPreferenceUseCase;
import com.conversationalhub.domain.ports.out.UserChannelPreferenceRepositoryPort;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserChannelPreferenceService implements UserChannelPreferenceUseCase {

    private final UserChannelPreferenceRepositoryPort repositoryPort;

    @Override
    @Transactional
    public UserChannelPreference savePreference(UserChannelPreference preference) {
        return repositoryPort.save(preference);
    }

    @Override
    public List<UserChannelPreference> getPreferencesByUser(String userId) {
        return repositoryPort.findByUserId(userId);
    }

    @Override
    @Transactional
    public UserChannelPreference updatePinStatus(String userId, String channelId, boolean isPinned) {
        UserChannelPreference pref = repositoryPort.findByUserIdAndChannelId(userId, channelId)
                .orElse(UserChannelPreference.builder()
                        .userId(userId)
                        .channelId(channelId)
                        .build());
        pref.setPinned(isPinned);
        return repositoryPort.save(pref);
    }

    @Override
    @Transactional
    public UserChannelPreference updateArchiveStatus(String userId, String channelId, boolean isArchived) {
        UserChannelPreference pref = repositoryPort.findByUserIdAndChannelId(userId, channelId)
                .orElse(UserChannelPreference.builder()
                        .userId(userId)
                        .channelId(channelId)
                        .build());
        pref.setArchived(isArchived);
        return repositoryPort.save(pref);
    }
}
