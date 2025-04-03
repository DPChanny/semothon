package com.semothon.spring_server.user.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.semothon.spring_server.chat.entity.ChatMessage;
import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.entity.ChatUser;
import com.semothon.spring_server.crawling.entity.UserCrawlingRecommendation;
import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.room.entity.RoomUser;
import com.semothon.spring_server.room.entity.UserRoomRecommendation;
import com.semothon.spring_server.user.dto.UpdateUserProfileRequestDto;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

//추후 기능 및 DB가 확정이 되면 각 DB마다 Index 추가 설정
@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString(of = {"userId", "nickname", "department", "studentId", "birthdate", "gender", "profileImageUrl", "socialProvider", "socialId", "introText", "shortIntro", "createdAt"})
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
    private String userId;

    @Column(length = 50)
    private String name;

    @Column(length = 50 ,unique = true)
    private String nickname;

    @Column(length = 100)
    private String department;

    @Column(length = 30)
    private String studentId;

    @Column(columnDefinition = "TIMESTAMP")
    private LocalDate birthdate;

    @Enumerated(EnumType.STRING)
    @Column(length = 10)
    private Gender gender;

    private String profileImageUrl;

    @Column(nullable = false, length = 50)
    private String socialProvider;

    @Column(nullable = false, length = 100)
    private String socialId;

    @Column(columnDefinition = "TEXT")
    private String introText;

    @Column(columnDefinition = "TEXT")
    private String shortIntro;

    @CreationTimestamp
    @Column(updatable = false, columnDefinition = "TIMESTAMP")
    private LocalDateTime createdAt;

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "host", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Room> hostedRooms = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "host", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ChatRoom> hostedChats = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<RoomUser> roomUsers = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserRoomRecommendation> userRoomRecommendations = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserInterest> userInterests = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<UserCrawlingRecommendation> userCrawlingRecommendations = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ChatMessage> chatMessages = new ArrayList<>();

    @JsonIgnore
    @Builder.Default
    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<ChatUser> chatUsers = new ArrayList<>();

    @PrePersist
    public void assignRandomDefaultProfileImageIfNull() {
        if (this.profileImageUrl == null) {
            int random = new Random().nextInt(6) + 1;
            this.profileImageUrl = "https://semothon.s3.ap-northeast-2.amazonaws.com/profile-images/default" + random + ".png";
        }
    }

    public void addHostedRooms(Room room){ //사용 x 연관계 편의 메서드 구성을 위한 메서드 <- hostRoom 추가는 연관관계 편의 메서드를 이용
        this.hostedRooms.add(room);
    }

    public void addHostedChats(ChatRoom chatRoom){ //사용 x 연관계 편의 메서드 구성을 위한 메서드 <- hostRoom 추가는 연관관계 편의 메서드를 이용
        this.hostedChats.add(chatRoom);
    }

    public void addRoomUser(RoomUser roomUser){
        this.roomUsers.add(roomUser);
    }

    public void addUserRoomRecommendation(UserRoomRecommendation userRoomRecommendation){
        this.userRoomRecommendations.add(userRoomRecommendation);
    }

    protected void addUserInterest(UserInterest userInterest){
        this.userInterests.add(userInterest);
    }

    public void addUserCrawlingRecommendation(UserCrawlingRecommendation userCrawlingRecommendation){
        this.userCrawlingRecommendations.add(userCrawlingRecommendation);
    }

    public void addChatMessage(ChatMessage chatMessage){
        this.chatMessages.add(chatMessage);
    }

    public void addChatUser(ChatUser chatUser){
        this.chatUsers.add(chatUser);
    }

    public void updateProfile(UpdateUserProfileRequestDto dto) {
        if (dto.getName() != null) this.name = dto.getName();
        if (dto.getNickname() != null) this.nickname = dto.getNickname();
        if (dto.getDepartment() != null) this.department = dto.getDepartment();
        if (dto.getStudentId() != null) this.studentId = dto.getStudentId();
        if (dto.getBirthdate() != null) this.birthdate = dto.getBirthdate();
        if (dto.getGender() != null) this.gender = dto.getGender();
        if (dto.getShortIntro() != null) this.shortIntro = dto.getShortIntro();
    }

    public void updateProfileImage(String profileImageUrl){
        this.profileImageUrl = profileImageUrl;
    }

    public void updateIntroText(String introText){
        this.introText = introText;
    }
}
