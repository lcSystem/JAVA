package com.conversationalhub.infrastructure.persistence.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.IdClass;
import jakarta.persistence.Table;
import lombok.*;

import java.io.Serializable;

@Entity
@Table(name = "user_channel_preferences")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@IdClass(UserChannelPreferenceEntity.UserChannelPreferenceId.class)
public class UserChannelPreferenceEntity {

    @Id
    @Column(name = "user_id")
    private String userId;

    @Id
    @Column(name = "channel_id")
    private String channelId;

    @Column(name = "is_pinned")
    private boolean isPinned;

    @Column(name = "is_archived")
    private boolean isArchived;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class UserChannelPreferenceId implements Serializable {
        private String userId;
        private String channelId;
    }
}
