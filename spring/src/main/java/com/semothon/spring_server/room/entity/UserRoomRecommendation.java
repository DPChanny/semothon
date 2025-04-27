package com.semothon.spring_server.room.entity;

import com.semothon.spring_server.user.entity.User;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"userRoomRecId", "score", "activityScore"})
@Table(name = "user_room_recommendations",
        indexes = {
        },
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"room_id", "user_id"})
        }
)
public class UserRoomRecommendation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userRoomRecId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @Column(nullable = false)
    private Double score;

    @Column(nullable = false)
    private Double activityScore;

    public void updateUser(User user){
        this.user = user;
        user.addUserRoomRecommendation(this);
    }

    public void updateRoom(Room room){
        this.room = room;
        room.addUserRoomRecommendation(this);
    }

    public void updateActivityScore(Double score) {
        this.activityScore = score;
    }

}
