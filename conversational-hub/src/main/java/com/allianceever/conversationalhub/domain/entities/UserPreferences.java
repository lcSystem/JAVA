package com.allianceever.conversationalhub.domain.entities;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserPreferences implements Serializable {
    private String userId;
    private String chatColor;
    private boolean isFloatingBubble;
    private String themeMode;
}
