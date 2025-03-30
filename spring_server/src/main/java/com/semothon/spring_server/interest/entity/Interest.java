package com.semothon.spring_server.interest.entity;


import com.fasterxml.jackson.annotation.JsonIgnore;
import com.semothon.spring_server.crawling.entity.CrawlingInterest;
import com.semothon.spring_server.room.entity.RoomInterest;
import com.semothon.spring_server.user.entity.UserInterest;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"interestId", "name"})
@Table(name = "interests",
        indexes = {
        },
        uniqueConstraints = {
        }
)
public class Interest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long interestId;

    @Column(nullable = false, length = 100)
    private String name;

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "interest", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserInterest> userInterests = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "interest", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RoomInterest> roomInterests = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "interest", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CrawlingInterest> crawlingInterests = new ArrayList<>();

    public void addUserInterest(UserInterest userInterest){
        this.userInterests.add(userInterest);
    }

    public void addRoomInterest(RoomInterest roomInterest){
        this.roomInterests.add(roomInterest);
    }

    public void addCrawlingInterest(CrawlingInterest crawlingInterest) {
        this.crawlingInterests.add(crawlingInterest);
    }
}
