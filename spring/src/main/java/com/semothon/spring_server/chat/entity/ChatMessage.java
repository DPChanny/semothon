package com.semothon.spring_server.chat.entity;

import com.semothon.spring_server.user.entity.User;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"chatMessageId", "message", "createdAt"})
@Table(name = "chat_messages",
        indexes = {
        },
        uniqueConstraints = {
        }
)
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long chatMessageId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chat_room_id", nullable = false)
    private ChatRoom chatRoom;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(columnDefinition = "TEXT")
    private String message;

    private String imageUrl;

    @CreationTimestamp
    @Column(updatable = false, columnDefinition = "TIMESTAMP")
    private LocalDateTime createdAt;

    public void updateUser(User user){
        this.user = user;
        user.addChatMessage(this);
    }

    public void updateChatRoom(ChatRoom chatRoom){
        this.chatRoom = chatRoom;
        chatRoom.addChatMessage(this);
    }
}
