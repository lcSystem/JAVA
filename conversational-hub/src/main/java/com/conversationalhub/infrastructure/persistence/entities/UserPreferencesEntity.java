package com.conversationalhub.infrastructure.persistence.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

@Entity
@Table(name = "user_preferences")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserPreferencesEntity {

    @Id
    @Column(name = "user_id")
    private String userId;

    @Column(name = "chat_color")
    private String chatColor;

    @Column(name = "is_floating_bubble")
    private boolean isFloatingBubble;

    @Column(name = "theme_mode")
    private String themeMode;
}
