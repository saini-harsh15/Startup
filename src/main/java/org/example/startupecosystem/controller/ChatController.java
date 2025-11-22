package org.example.startupecosystem.controller;

import org.example.startupecosystem.entity.ChatMessage;
import org.example.startupecosystem.repository.ChatMessageRepository;
import org.example.startupecosystem.repository.StartupRepository; // Assuming this is needed for context
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;

@Controller
public class ChatController {

    // Used to send messages to specific WebSocket destinations
    @Autowired
    private SimpMessagingTemplate messagingTemplate; 

    // Used to persist the messages to the MySQL database
    @Autowired
    private ChatMessageRepository chatMessageRepository;

    /**
     * Handles incoming chat messages sent to /app/chat.
     * @param chatMessage The message object received from the client.
     */
    @MessageMapping("/chat")
    public void processMessage(ChatMessage chatMessage) {
        // 1. Set the timestamp (Crucial for history)
        chatMessage.setTimestamp(LocalDateTime.now());
        
        // 2. Persist the message to the MySQL database
        chatMessageRepository.save(chatMessage);
        
        // 3. Broadcast the message to the recipient's specific channel.
        // The recipient subscribes to /topic/messages/{receiverId}.
        // This ensures only the intended recipient gets the real-time update.
        // We also send it back to the sender's own channel for immediate display confirmation.
        
        // Send to receiver
        messagingTemplate.convertAndSend("/topic/messages/" + chatMessage.getReceiverId(), chatMessage);
        
        // Send back to sender (for confirmation/display on their screen)
        messagingTemplate.convertAndSend("/topic/messages/" + chatMessage.getSenderId(), chatMessage);
    }
}