package org.example.startupecosystem.controller;

import org.example.startupecosystem.entity.ChatMessage;
import org.example.startupecosystem.service.ChatService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/chat")
public class ChatHistoryController {

    @Autowired
    private ChatService chatService;

    // GET /api/chat/history?userId1=...&userId2=...
    @GetMapping("/history")
    public ResponseEntity<List<ChatMessage>> getChatHistory(
            @RequestParam("userId1") Long userId1,
            @RequestParam("userId2") Long userId2) {
        List<ChatMessage> history = chatService.getConversationHistory(userId1, userId2);
        return ResponseEntity.ok(history);
    }
}
