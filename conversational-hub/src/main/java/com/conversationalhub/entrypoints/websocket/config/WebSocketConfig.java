package com.conversationalhub.entrypoints.websocket.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.config.ChannelRegistration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

import java.util.List;

@Slf4j
@Configuration
@EnableWebSocketMessageBroker
@RequiredArgsConstructor
@Order(Ordered.HIGHEST_PRECEDENCE + 99)
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    private final JwtDecoder jwtDecoder;
    private final com.conversationalhub.application.services.PresenceService presenceService;

    @Value("${spring.rabbitmq.host:localhost}")
    private String rabbitmqHost;

    @Value("${spring.rabbitmq.username:guest}")
    private String rabbitmqUser;

    @Value("${spring.rabbitmq.password:guest}")
    private String rabbitmqPassword;

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        registry.addEndpoint("/ws/chat")
                .setAllowedOriginPatterns("*")
                .withSockJS();

        // También exponemos el endpoint sin sockjs para clientes nativos o Flutter puro
        registry.addEndpoint("/ws/chat")
                .setAllowedOriginPatterns("*");
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // Habilitamos el Broker Relay que envía los mensajes reales hacia RabbitMQ
        // (AMQP -> STOMP)
        registry.enableStompBrokerRelay("/topic", "/queue", "/exchange")
                .setRelayHost(java.util.Objects.requireNonNull(rabbitmqHost))
                .setRelayPort(61613) // Puerto STOMP de RabbitMQ
                .setClientLogin(java.util.Objects.requireNonNull(rabbitmqUser))
                .setClientPasscode(java.util.Objects.requireNonNull(rabbitmqPassword))
                .setSystemLogin(java.util.Objects.requireNonNull(rabbitmqUser))
                .setSystemPasscode(java.util.Objects.requireNonNull(rabbitmqPassword));

        // Los mensajes que el cliente envíe al servidor con prefijo /app serán
        // procesados por los @MessageMapping
        registry.setApplicationDestinationPrefixes("/app");
        // Los mensajes dirigidos a usuarios específicos tendrán el prefijo /user
        registry.setUserDestinationPrefix("/user");
    }

    @Override
    public void configureClientInboundChannel(ChannelRegistration registration) {
        registration.interceptors(new ChannelInterceptor() {
            @SuppressWarnings("null")
            @Override
            public Message<?> preSend(Message<?> message, MessageChannel channel) {
                StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
                if (accessor != null) {
                    if (StompCommand.CONNECT.equals(accessor.getCommand())) {
                        handleConnect(accessor);
                    } else if (StompCommand.DISCONNECT.equals(accessor.getCommand())) {
                        handleDisconnect(accessor);
                    }
                }
                return message;
            }

            private void handleConnect(StompHeaderAccessor accessor) {
                List<String> authorization = accessor.getNativeHeader("Authorization");
                if (authorization != null && !authorization.isEmpty()) {
                    String bearerToken = authorization.get(0);
                    if (bearerToken.startsWith("Bearer ")) {
                        String token = bearerToken.substring(7);
                        try {
                            Jwt jwt = jwtDecoder.decode(token);
                            JwtAuthenticationToken authentication = new JwtAuthenticationToken(jwt);
                            accessor.setUser(authentication);
                            presenceService.markAsOnline(jwt.getSubject());
                            log.info("Usuario '{}' conectado y marcado como ONLINE", jwt.getSubject());
                        } catch (Exception e) {
                            log.error("JWT Inválido durante conexión STOMP", e);
                        }
                    }
                }
            }

            private void handleDisconnect(StompHeaderAccessor accessor) {
                java.security.Principal user = accessor.getUser();
                if (user != null) {
                    presenceService.markAsOffline(user.getName());
                    log.info("Usuario '{}' desconectado y marcado como OFFLINE", user.getName());
                }
            }
        });
    }
}
