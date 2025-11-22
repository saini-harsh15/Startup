package org.example.startupecosystem.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "chat_messages")
public class ChatMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "sender_id")
    private Long senderId; // ID of the user sending the message (Startup or Investor)

    @Column(name = "receiver_id")
    private Long receiverId; // ID of the intended recipient

    @Column(name = "content", length = 500)
    private String content;

    @Column(name = "timestamp")
    private LocalDateTime timestamp;

    // Constructors
    public ChatMessage() {
        this.timestamp = LocalDateTime.now();
    }

    // Getters and Setters (omitted for brevity, but needed by JPA)

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getSenderId() { return senderId; }
    public void setSenderId(Long senderId) { this.senderId = senderId; }
    public Long getReceiverId() { return receiverId; }
    public void setReceiverId(Long receiverId) { this.receiverId = receiverId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public LocalDateTime getTimestamp() { return timestamp; }
    public void setTimestamp(LocalDateTime timestamp) { this.timestamp = timestamp; }
}