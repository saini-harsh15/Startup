package org.example.startupecosystem.Configuration;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.messaging.converter.MappingJackson2MessageConverter;
import org.springframework.messaging.converter.MessageConverter;

import java.util.List;

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
        // setAllowedOriginPatterns("*") ensures the WS handshake isn't blocked by origin checks
        // when accessed from different hosts/ports or behind proxies during development.
        registry.addEndpoint("/ws-chat").setAllowedOriginPatterns("*").withSockJS();
    }

    @Override
    public boolean configureMessageConverters(List<MessageConverter> messageConverters) {

        MappingJackson2MessageConverter converter = new MappingJackson2MessageConverter();
        converter.setObjectMapper(new ObjectMapper());
        converter.setPrettyPrint(false);

        messageConverters.add(converter);

        // return false → keep default converters + add this one
        return false;
    }
}