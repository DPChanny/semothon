package com.semothon.spring_server.user.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

//추후 기능 및 DB가 확정이 되면 각 DB마다 Index 추가 설정
@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"userId", "nickname", "department", "studentId", "age", "gender", "profileImageUrl", "socialProvider", "socialId", "introText", "createdAt"})
@Table(name = "users",
        indexes = {
        },
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"nickname"}),
                @UniqueConstraint(columnNames = {"socialProvider", "socialId"})
        }
)
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long userId;

    @Column(nullable = false, length = 50 ,unique = true)
    private String nickname;

    @Column(nullable = false, length = 100)
    private String department;

    @Column(nullable = false, length = 30)
    private String studentId;

    @Column(nullable = false)
    private Integer age;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Gender gender;

    @Column(length = 255)
    private String profileImageUrl;

    @Column(nullable = false, length = 50)
    private String socialProvider;

    @Column(nullable = false, length = 100)
    private String socialId;

    @Column(columnDefinition = "TEXT")
    private String introText;

    @CreationTimestamp
    @Column(updatable = false, columnDefinition = "TIMESTAMP")
    private LocalDateTime createdAt;
}
