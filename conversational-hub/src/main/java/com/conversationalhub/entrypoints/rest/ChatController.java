package com.conversationalhub.entrypoints.rest;

import com.conversationalhub.domain.entities.Channel;
import com.conversationalhub.domain.entities.Message;
import com.conversationalhub.domain.ports.in.ChatUseCase;
import com.conversationalhub.infrastructure.auth.AuthAdapter;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {
    private final ChatUseCase chatService;
    private final AuthAdapter authAdapter;
    private final com.conversationalhub.application.services.PresenceService presenceService;
    private final com.conversationalhub.infrastructure.clients.EmployeeClient employeeClient;
    private final com.conversationalhub.domain.ports.in.UserChannelPreferenceUseCase userChannelPreferenceUseCase;

    @PostMapping("/channels")
    public ResponseEntity<Channel> createChannel(@RequestBody Channel channel) {
        channel.setTenantId(authAdapter.getCurrentTenantId());
        return new ResponseEntity<>(chatService.createChannel(channel), HttpStatus.CREATED);
    }

    @GetMapping("/channels")
    public ResponseEntity<List<ChannelResponseDTO>> getChannels() {
        String userId = authAdapter.getCurrentUserId();
        String tenantId = authAdapter.getCurrentTenantId();
        List<Channel> channels = chatService.getChannelsByTenant(tenantId);
        List<com.conversationalhub.domain.entities.UserChannelPreference> prefs = userChannelPreferenceUseCase
                .getPreferencesByUser(userId);

        java.util.Map<String, com.conversationalhub.domain.entities.UserChannelPreference> prefMap = prefs.stream()
                .collect(java.util.stream.Collectors
                        .toMap(com.conversationalhub.domain.entities.UserChannelPreference::getChannelId, p -> p));

        List<ChannelResponseDTO> response = channels.stream()
                .map(c -> {
                    com.conversationalhub.domain.entities.UserChannelPreference p = prefMap.get(c.getId());
                    return new ChannelResponseDTO(c, p != null && p.isPinned(), p != null && p.isArchived());
                })
                .collect(java.util.stream.Collectors.toList());

        return ResponseEntity.ok(response);
    }

    @lombok.Data
    @lombok.AllArgsConstructor
    public static class ChannelResponseDTO {
        private Channel channel;
        private boolean pinned;
        private boolean archived;
    }

    @GetMapping("/channels/{channelId}/messages")
    public ResponseEntity<List<Message>> getMessages(@PathVariable String channelId) {
        return ResponseEntity.ok(chatService.getMessagesByChannel(channelId));
    }

    @PostMapping("/channels/{channelId}/messages")
    public ResponseEntity<Message> sendMessage(@PathVariable String channelId, @RequestBody Message message) {
        message.setChannelId(channelId);
        message.setSenderId(authAdapter.getCurrentUserId());
        return new ResponseEntity<>(chatService.sendMessage(message), HttpStatus.CREATED);
    }

    @GetMapping("/sync")
    public ResponseEntity<List<Message>> syncMessages(@RequestParam("since") String sinceStr) {
        String userId = authAdapter.getCurrentUserId();
        java.time.LocalDateTime since = java.time.LocalDateTime.parse(sinceStr);
        return ResponseEntity.ok(chatService.getMessagesSince(userId, since));
    }

    @GetMapping("/users")
    public ResponseEntity<List<UserStatusDTO>> getUsers() {
        java.util.Set<String> onlineUserIds = presenceService.getOnlineUsers();
        List<com.conversationalhub.infrastructure.clients.EmployeeClient.EmployeeSummaryDTO> employees = employeeClient
                .getAllEmployees();

        List<UserStatusDTO> users = employees.stream()
                .map(emp -> new UserStatusDTO(
                        emp.getUsername(),
                        (emp.getFirstName() != null ? emp.getFirstName() : "") + " " +
                                (emp.getLastName() != null ? emp.getLastName() : ""),
                        onlineUserIds.contains(emp.getUsername())))
                .collect(java.util.stream.Collectors.toList());

        return ResponseEntity.ok(users);
    }

    @lombok.Data
    @lombok.AllArgsConstructor
    public static class UserStatusDTO {
        private String userId;
        private String username;
        private boolean online;
    }
}
