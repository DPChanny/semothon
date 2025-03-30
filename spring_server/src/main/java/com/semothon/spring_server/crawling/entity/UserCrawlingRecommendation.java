package com.semothon.spring_server.crawling.entity;

import com.semothon.spring_server.user.entity.User;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"userCrawlingRecId", "score", "activityScore"})
@Table(name = "user_crawling_recommendations",
        indexes = {
        },
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"user_id", "crawling_id"})
        }
)
public class UserCrawlingRecommendation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userCrawlingRecId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "crawling_id", nullable = false)
    private Crawling crawling;

    @Column(nullable = false)
    private Double score;

    @Column(nullable = false)
    private Double activityScore;

    public void updateUser(User user){
        this.user = user;
        user.addUserCrawlingRecommendation(this);
    }

    public void updateCrawlingData(Crawling crawling){
        this.crawling = crawling;
        crawling.addUserCrawlingRecommendation(this);
    }

    public void updateActivityScore(Double score) {
        this.activityScore = score;
    }

}

