package com.allianceever.conversationalhub.entrypoints.rest;

import com.allianceever.conversationalhub.domain.entities.Channel;
import com.allianceever.conversationalhub.domain.entities.Message;
import com.allianceever.conversationalhub.domain.ports.in.ChatUseCase;
import com.allianceever.conversationalhub.infrastructure.auth.AuthAdapter;
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

    @PostMapping("/channels")
    public ResponseEntity<Channel> createChannel(@RequestBody Channel channel) {
        channel.setTenantId(authAdapter.getCurrentTenantId());
        return new ResponseEntity<>(chatService.createChannel(channel), HttpStatus.CREATED);
    }

    @GetMapping("/channels")
    public ResponseEntity<List<Channel>> getChannels() {
        String tenantId = authAdapter.getCurrentTenantId();
        return ResponseEntity.ok(chatService.getChannelsByTenant(tenantId));
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
}
