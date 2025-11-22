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
        // Use the complex query to get all messages where (Sender=A AND Receiver=B) OR (Sender=B AND Receiver=A)
        return chatMessageRepository.findBySenderIdAndReceiverIdOrReceiverIdAndSenderIdOrderByTimestampAsc(
            userId1, userId2, userId2, userId1);
    }
}