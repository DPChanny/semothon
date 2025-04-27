package com.semothon.spring_server.user.entity;

import com.semothon.spring_server.interest.entity.Interest;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"userInterestId"})
@Table(name = "user_interests",
        indexes = {
        },
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"user_id", "interest_id"})
        }
)
public class UserInterest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userInterestId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "interest_id", nullable = false)
    private Interest interest;

    public void updateUser(User user){
        this.user = user;
        user.addUserInterest(this);
    }

    public void updateInterest(Interest interest){
        this.interest = interest;
        interest.addUserInterest(this);
    }
}
