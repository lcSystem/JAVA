package com.allianceever.conversationalhub.entrypoints.websocket;

import com.allianceever.conversationalhub.domain.entities.Message;
import com.allianceever.conversationalhub.domain.ports.in.ChatUseCase;
import com.allianceever.conversationalhub.domain.ports.out.NotificationPublisherPort;
import com.allianceever.conversationalhub.infrastructure.mq.dto.ChatNotificationEvent;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.security.Principal;
import java.time.LocalDateTime;

@Controller
@RequiredArgsConstructor
@Slf4j
public class StompChatController {

        private final ChatUseCase chatUseCase;
        private final SimpMessagingTemplate messagingTemplate;
        private final NotificationPublisherPort notificationPublisher;

        @MessageMapping("/chat.sendPrivate")
        public void sendPrivateMessage(@Payload PrivateMessageRequest request, Principal principal) {
                if (principal == null) {
                        log.error("Intento de envío de mensaje sin Principal autenticado.");
                        return;
                }

                String senderId = principal.getName(); // El ID extraído del JWT (sub) en el Handshake
                log.info("Mensaje STOMP recibido de {} para {}", senderId, request.getRecipientId());

                // 1. Crear y estructurar la entidad Message
                Message message = Message.builder()
                                .senderId(senderId)
                                .recipientId(request.getRecipientId())
                                .channelId(request.getChannelId())
                                .content(request.getContent())
                                .type(Message.MessageType.TEXT)
                                .timestamp(LocalDateTime.now())
                                .build();

                // 2. Persistir en base de datos PostgreSQL mediante el caso de uso
                Message savedMessage = chatUseCase.sendMessage(message);

                // 3. Notificar vía RabbitMQ para el microservicio de notificaciones push
                ChatNotificationEvent notification = ChatNotificationEvent.builder()
                                .senderId(senderId)
                                .recipientId(request.getRecipientId())
                                .messageSnippet(request.getContent().length() > 50
                                                ? request.getContent().substring(0, 47) + "..."
                                                : request.getContent())
                                .channelId(request.getChannelId())
                                .build();
                notificationPublisher.pushNotification(notification);

                // 4. Empujar a RabbitMQ (Broker Relay) apuntando EXCLUSIVAMENTE al receptor
                String recipientId = request.getRecipientId();
                if (recipientId != null && savedMessage != null) {
                        messagingTemplate.convertAndSendToUser(
                                        recipientId,
                                        "/queue/messages",
                                        savedMessage);
                }

                // 5. Enviar también una confirmación / eco de vuelta al remitente
                if (senderId != null && savedMessage != null) {
                        messagingTemplate.convertAndSendToUser(
                                        senderId,
                                        "/queue/messages",
                                        savedMessage);
                }
        }

        @Data
        public static class PrivateMessageRequest {
                private String recipientId;
                private String channelId;
                private String content;
        }
}
