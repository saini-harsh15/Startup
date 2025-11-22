package org.example.startupecosystem.Configuration;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        // Enable an in-memory message broker with destination prefixes /topic (for broadcasting)
        // This is where the client will subscribe to receive real-time updates.
        config.enableSimpleBroker("/topic");

        // Define the prefix for application-specific destinations. 
        // Messages sent from the client with this prefix will be routed to a @Controller method.
        config.setApplicationDestinationPrefixes("/app");
    }

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // The endpoint the client connects to for the WebSocket handshake.
        // withSockJS() provides fallback options for browsers that don't natively support WebSockets.
        registry.addEndpoint("/ws-chat").withSockJS();
    }
}