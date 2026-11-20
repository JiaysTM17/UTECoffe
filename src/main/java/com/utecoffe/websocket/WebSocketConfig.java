package com.utecoffe.websocket;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.*;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // SockJS fallback for browsers without native WebSocket
        registry.addEndpoint("/ws-utecoffe")
                .setAllowedOriginPatterns("*")
                .withSockJS();

        // Native WebSocket endpoint
        registry.addEndpoint("/ws-utecoffe")
                .setAllowedOriginPatterns("*");
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // In-memory message broker with destination prefixes
        registry.enableSimpleBroker("/topic", "/queue");
        // Prefix for messages destined for methods annotated with @MessageMapping
        registry.setApplicationDestinationPrefixes("/app");
    }
}
