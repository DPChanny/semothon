package com.semothon.spring_server.chat.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.semothon.spring_server.crawling.entity.Crawling;
import com.semothon.spring_server.room.entity.Room;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"chatRoomId", "type", "createdAt"})
@Table(name = "chat_rooms",
        indexes = {
        },
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"room_id"})
        }
)
public class ChatRoom {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long chatRoomId;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private ChatRoomType type;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id", unique = true)
    private Room room;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "crawling_id")
    private Crawling crawling;

    @CreationTimestamp
    @Column(updatable = false, columnDefinition = "TIMESTAMP")
    private LocalDateTime createdAt;

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "chatRoom", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ChatMessage> chatMessages = new ArrayList<>();

    public void updateRoom(Room room){
        this.room = room;
        room.setChatRoom(this);
    }

    public void updateCrawling(Crawling crawling){
        this.crawling = crawling;
        crawling.addChatRoom(this);
    }

    protected void addChatMessage(ChatMessage chatMessage){
        this.chatMessages.add(chatMessage);
    }
}
