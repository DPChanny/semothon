package com.semothon.spring_server.crawling.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.semothon.spring_server.chat.entity.ChatRoom;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"crawlingId", "title", "url", "deadlinedAt", "crawledAt"})
@Table(name = "crawling",
        indexes = {
        },
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"url"})
        }
)
public class Crawling {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long crawlingId;

    @Column(nullable = false, length = 255)
    private String title;

    @Column(nullable = false, length = 500)
    private String url;

    private String imageUrl;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TIMESTAMP")
    private LocalDateTime deadlinedAt;

    @Column(columnDefinition = "TIMESTAMP")
    private LocalDateTime crawledAt;

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "crawling", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserCrawlingRecommendation> userCrawlingRecommendations = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "crawling", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ChatRoom> chatRooms = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "crawling", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CrawlingInterest> crawlingInterests = new ArrayList<>();

    protected void addUserCrawlingRecommendation(UserCrawlingRecommendation userCrawlingRecommendation){
        this.userCrawlingRecommendations.add(userCrawlingRecommendation);
    }

    protected void addCrawlingInterest(CrawlingInterest crawlingInterest){
        this.crawlingInterests.add(crawlingInterest);
    }

    public void addChatRoom(ChatRoom chatRoom){
        this.chatRooms.add(chatRoom);
    }
}
