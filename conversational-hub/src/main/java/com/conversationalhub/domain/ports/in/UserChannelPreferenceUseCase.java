package com.conversationalhub.domain.ports.in;

import com.conversationalhub.domain.entities.UserChannelPreference;
import java.util.List;

public interface UserChannelPreferenceUseCase {
    UserChannelPreference savePreference(UserChannelPreference preference);

    List<UserChannelPreference> getPreferencesByUser(String userId);

    UserChannelPreference updatePinStatus(String userId, String channelId, boolean isPinned);

    UserChannelPreference updateArchiveStatus(String userId, String channelId, boolean isArchived);
}
