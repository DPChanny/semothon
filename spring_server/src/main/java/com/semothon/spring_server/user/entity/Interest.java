package com.semothon.spring_server.user.entity;


import com.fasterxml.jackson.annotation.JsonIgnore;
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

    protected void addUserInterest(UserInterest userInterest){
        this.userInterests.add(userInterest);
    }

}
