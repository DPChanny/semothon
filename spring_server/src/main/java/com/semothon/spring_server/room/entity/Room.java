package com.semothon.spring_server.room.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.interest.entity.Interest;
import com.semothon.spring_server.room.dto.UpdateRoomRequestDto;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.entity.UserInterest;
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
@ToString(of = {"roomId", "title", "description", "createdAt"})
@Table(name = "rooms",
        indexes = {
        },
        uniqueConstraints = {
        }
)
public class Room {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long roomId;

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
    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RoomUser> roomUsers = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserRoomRecommendation> userRoomRecommendations = new ArrayList<>();

    @JsonIgnore
    @OneToOne(mappedBy = "room", cascade = CascadeType.ALL, orphanRemoval = true)
    private ChatRoom chatRoom;

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "room", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RoomInterest> roomInterests = new ArrayList<>();

    protected void addRoomUser(RoomUser roomUser){
        this.roomUsers.add(roomUser);
    }

    protected void addUserRoomRecommendation(UserRoomRecommendation userRoomRecommendation){
        this.userRoomRecommendations.add(userRoomRecommendation);
    }

    public void setChatRoom(ChatRoom chatRoom){
        this.chatRoom = chatRoom;
    }

    protected void addRoomInterest(RoomInterest roomInterest){
        this.roomInterests.add(roomInterest);
    }


    //연관관계 편의 메서드
    public void updateHost(User user){
        this.host = user;
        user.addHostedRooms(this);
    }

    public void updateRoom(UpdateRoomRequestDto dto){
        if (dto.getTitle() != null) this.title = dto.getTitle();
        if (dto.getDescription() != null) this.description = dto.getDescription();
        if (dto.getCapacity() != null) {
            if (dto.getCapacity() < roomUsers.size()) {
                throw new InvalidInputException("current member count is more than updated capacity. current member counts: " + roomUsers.size());
            }
            this.capacity = dto.getCapacity();
        }
    }
}
