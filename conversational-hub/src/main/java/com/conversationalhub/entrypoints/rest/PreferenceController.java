package com.conversationalhub.entrypoints.rest;

import com.conversationalhub.domain.entities.UserPreferences;
import com.conversationalhub.domain.ports.in.UserPreferencesUseCase;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/chat/preferences")
@RequiredArgsConstructor
public class PreferenceController {

    private final UserPreferencesUseCase userPreferencesUseCase;
    private final com.conversationalhub.domain.ports.in.UserChannelPreferenceUseCase userChannelPreferenceUseCase;

    @GetMapping
    public ResponseEntity<UserPreferences> getPreferences(@AuthenticationPrincipal Jwt jwt) {
        String userId = jwt.getSubject();
        return ResponseEntity.ok(userPreferencesUseCase.getPreferences(userId));
    }

    @PostMapping
    public ResponseEntity<UserPreferences> savePreferences(
            @RequestBody UserPreferences preferences,
            @AuthenticationPrincipal Jwt jwt) {
        String userId = jwt.getSubject();
        preferences.setUserId(userId);
        return ResponseEntity.ok(userPreferencesUseCase.savePreferences(preferences));
    }

    @PutMapping("/channels/{channelId}/pin")
    public ResponseEntity<com.conversationalhub.domain.entities.UserChannelPreference> pinChannel(
            @PathVariable String channelId,
            @RequestParam boolean pinned,
            @AuthenticationPrincipal Jwt jwt) {
        String userId = jwt.getSubject();
        return ResponseEntity.ok(userChannelPreferenceUseCase.updatePinStatus(userId, channelId, pinned));
    }

    @PutMapping("/channels/{channelId}/archive")
    public ResponseEntity<com.conversationalhub.domain.entities.UserChannelPreference> archiveChannel(
            @PathVariable String channelId,
            @RequestParam boolean archived,
            @AuthenticationPrincipal Jwt jwt) {
        String userId = jwt.getSubject();
        return ResponseEntity.ok(userChannelPreferenceUseCase.updateArchiveStatus(userId, channelId, archived));
    }
}
