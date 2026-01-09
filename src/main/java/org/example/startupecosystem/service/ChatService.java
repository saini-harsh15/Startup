package org.example.startupecosystem.service;

import org.example.startupecosystem.entity.ChatMessage;
import org.example.startupecosystem.repository.ChatMessageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ChatService {

    @Autowired
    private ChatMessageRepository chatMessageRepository;

    public List<ChatMessage> getConversationHistory(Long userId1, Long userId2) {
        // Fetch all messages where (sender=A AND receiver=B) OR (sender=B AND receiver=A), ordered by timestamp ASC
        return chatMessageRepository.findConversationBetween(userId1, userId2);
    }
}