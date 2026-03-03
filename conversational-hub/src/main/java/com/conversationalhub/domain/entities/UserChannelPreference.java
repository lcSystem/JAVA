package com.conversationalhub.domain.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserChannelPreference {
    private String userId;
    private String channelId;
    private boolean isPinned;
    private boolean isArchived;
}
