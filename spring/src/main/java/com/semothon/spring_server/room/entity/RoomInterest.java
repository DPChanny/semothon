package com.semothon.spring_server.room.entity;

import com.semothon.spring_server.interest.entity.Interest;
import com.semothon.spring_server.user.entity.User;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"roomInterestId"})
@Table(name = "room_interests",
        indexes = {
        },
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"room_id", "interest_id"})
        }
)
public class RoomInterest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long roomInterestId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "room_id", nullable = false)
    private Room room;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "interest_id", nullable = false)
    private Interest interest;

    public void updateRoom(Room room){
        this.room = room;
        room.addRoomInterest(this);
    }

    public void updateInterest(Interest interest){
        this.interest = interest;
        interest.addRoomInterest(this);
    }
}
