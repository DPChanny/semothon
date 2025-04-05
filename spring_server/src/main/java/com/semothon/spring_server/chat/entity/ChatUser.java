package com.semothon.spring_server.chat.entity;

import com.semothon.spring_server.room.entity.RoomUserRole;
import com.semothon.spring_server.user.entity.User;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"chatUserId", "joinedAt", "role"})
@Table(name = "chat_users",
        indexes = {
        },
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"chat_room_id", "user_id"})
        }
)
public class ChatUser {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long chatUserId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "chat_room_id", nullable = false)
    private ChatRoom chatRoom;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @CreationTimestamp
    @Column(updatable = false, columnDefinition = "TIMESTAMP")
    private LocalDateTime joinedAt;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ChatUserRole role;

    @Column(name = "last_read_at", columnDefinition = "TIMESTAMP")
    @Builder.Default
    private LocalDateTime lastReadAt = LocalDateTime.now();

    public void updateUser(User user){
        this.user = user;
        user.addChatUser(this);
    }

    public void updateChatRoom(ChatRoom chatRoom){
        this.chatRoom = chatRoom;
        chatRoom.addChatUser(this);
    }

    public void updateLastReadAt(LocalDateTime time) {
        this.lastReadAt = time;
    }
}
