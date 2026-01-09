package org.example.startupecosystem.dto;

public class TypingNotification {
    private Long from;
    private Long to;
    private boolean typing;

    public TypingNotification() {}

    public TypingNotification(Long from, Long to, boolean typing) {
        this.from = from;
        this.to = to;
        this.typing = typing;
    }

    public Long getFrom() {
        return from;
    }

    public void setFrom(Long from) {
        this.from = from;
    }

    public Long getTo() {
        return to;
    }

    public void setTo(Long to) {
        this.to = to;
    }

    public boolean isTyping() {
        return typing;
    }

    public void setTyping(boolean typing) {
        this.typing = typing;
    }
}
