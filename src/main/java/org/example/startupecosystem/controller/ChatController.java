package org.example.startupecosystem.controller;

import org.example.startupecosystem.entity.ChatMessage;
import org.example.startupecosystem.repository.ChatMessageRepository;
import org.example.startupecosystem.dto.TypingNotification;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;

@Controller
public class ChatController {

    @Autowired
    private SimpMessagingTemplate messagingTemplate; 

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    /**
     * Handles incoming chat messages sent to /app/chat.
     */
    @MessageMapping("/chat")
    public void processMessage(ChatMessage chatMessage) {
        // Set timestamp and persist
        chatMessage.setTimestamp(LocalDateTime.now());
        chatMessageRepository.save(chatMessage);

        // Broadcast to both receiver and sender channels
        messagingTemplate.convertAndSend("/topic/messages/" + chatMessage.getReceiverId(), chatMessage);
        messagingTemplate.convertAndSend("/topic/messages/" + chatMessage.getSenderId(), chatMessage);
    }

    /**
     * Typing indicator relay: client sends to /app/typing and we forward to recipient topic.
     */
    @MessageMapping("/typing")
    public void typing(TypingNotification typing) {
        if (typing == null || typing.getTo() == null) return;
        messagingTemplate.convertAndSend("/topic/typing/" + typing.getTo(), typing);
    }
}