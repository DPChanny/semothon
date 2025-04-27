package com.semothon.spring_server.crawling.entity;

import com.semothon.spring_server.interest.entity.Interest;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"crawlingInterestId"})
@Table(name = "crawling_interests",
        indexes = {
        },
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"crawling_id", "interest_id"})
        }
)
public class CrawlingInterest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long crawlingInterestId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "crawling_id", nullable = false)
    private Crawling crawling;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "interest_id", nullable = false)
    private Interest interest;

    public void updateCrawling(Crawling crawling){
        this.crawling = crawling;
        crawling.addCrawlingInterest(this);
    }

    public void updateInterest(Interest interest){
        this.interest = interest;
        interest.addCrawlingInterest(this);
    }
}
