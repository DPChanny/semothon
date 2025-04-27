package com.semothon.spring_server.room.entity;

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
@ToString(of = {"roomUserId", "role", "joinedAt"})
@Table(name = "room_users",
        indexes = {
        },
        uniqueConstraints = {
            @UniqueConstraint(columnNames = {"room_id", "user_id"})
        }
)
public class RoomUser {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long roomUserId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private RoomUserRole role;

    @CreationTimestamp
    @Column(updatable = false, columnDefinition = "TIMESTAMP")
    private LocalDateTime joinedAt;



    //연관관계 편의 메서드
    public void updateUser(User user){
        this.user = user;
        user.addRoomUser(this);
    }

    public void updateRoom(Room room){
        this.room = room;
        room.addRoomUser(this);
    }

}
