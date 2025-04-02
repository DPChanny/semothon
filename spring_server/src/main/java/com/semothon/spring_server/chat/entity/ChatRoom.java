package com.semothon.spring_server.chat.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.semothon.spring_server.chat.dto.UpdateChatRoomRequestDto;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.crawling.entity.Crawling;
import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.user.entity.User;
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

    @Column(nullable = false, length = 100)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "host_user_id", nullable = false)
    private User host;

    @Column(nullable = false)
    @Builder.Default //기본값 30명
    private Integer capacity = 30;

    @CreationTimestamp
    @Column(updatable = false, columnDefinition = "TIMESTAMP")
    private LocalDateTime createdAt;

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "chatRoom", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ChatMessage> chatMessages = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "chatRoom", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ChatUser> chatUsers = new ArrayList<>();

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

    protected void addChatUser(ChatUser chatUser){
        this.chatUsers.add(chatUser);
    }

    public void updateHost(User user){
        this.host = user;
        user.addHostedChats(this);
    }

    public void updateChatRoom(UpdateChatRoomRequestDto dto){
        if (dto.getTitle() != null) {
            this.title = dto.getTitle();
        }
        if (dto.getDescription() != null) {
            this.description = dto.getDescription();
        }
        if (dto.getCapacity() != null) {
            int currentSize = this.chatUsers.size();
            if (dto.getCapacity() < currentSize) {
                throw new InvalidInputException("current member count is more than updated capacity. current member counts: " + currentSize);
            }
            this.capacity = dto.getCapacity();
        }
    }
}
