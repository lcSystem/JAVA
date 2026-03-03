package com.conversationalhub.domain.ports.out;

import com.conversationalhub.domain.entities.UserChannelPreference;
import java.util.List;
import java.util.Optional;

public interface UserChannelPreferenceRepositoryPort {
    UserChannelPreference save(UserChannelPreference preference);

    Optional<UserChannelPreference> findByUserIdAndChannelId(String userId, String channelId);

    List<UserChannelPreference> findByUserId(String userId);
}
