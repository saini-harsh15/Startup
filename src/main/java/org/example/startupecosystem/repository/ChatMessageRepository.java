package org.example.startupecosystem.repository;

import org.example.startupecosystem.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {

    @Query("SELECT m FROM ChatMessage m " +
           "WHERE (m.senderId = :userA AND m.receiverId = :userB) " +
           "   OR (m.senderId = :userB AND m.receiverId = :userA) " +
           "ORDER BY m.timestamp ASC")
    List<ChatMessage> findConversationBetween(@Param("userA") Long userA, @Param("userB") Long userB);


    @Query("""
    SELECT DISTINCT 
        CASE 
            WHEN m.senderId = :userId THEN m.receiverId
            ELSE m.senderId
        END
    FROM ChatMessage m
    WHERE m.senderId = :userId OR m.receiverId = :userId
""")
    List<Long> findChatPartnerIds(@Param("userId") Long userId);

    @Query("""
       SELECT m FROM ChatMessage m
       WHERE m.senderId = :userId OR m.receiverId = :userId
       ORDER BY m.timestamp DESC
       """)
    List<ChatMessage> findAllUserMessagesOrdered(@Param("userId") Long userId);


}