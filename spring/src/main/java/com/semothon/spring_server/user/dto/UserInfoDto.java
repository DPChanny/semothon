package com.semothon.spring_server.user.dto;

import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.user.entity.Gender;
import com.semothon.spring_server.user.entity.User;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class UserInfoDto {

    private String userId;
    private String name;
    private String nickname;
    private String department;
    private String studentId;
    private LocalDate birthdate;
    private Gender gender;
    private String profileImageUrl;
    private String socialProvider;
    private String socialId;
    private String introText;
    private String shortIntro;
    private LocalDateTime createdAt;
    private List<String> interests;

    public static UserInfoDto from(User user) {
        return UserInfoDto.builder()
                .userId(user.getUserId())
                .name(user.getName())
                .nickname(user.getNickname())
                .department(user.getDepartment())
                .studentId(user.getStudentId())
                .birthdate(user.getBirthdate())
                .gender(user.getGender())
                .profileImageUrl(user.getProfileImageUrl())
                .socialProvider(user.getSocialProvider())
                .socialId(user.getSocialId())
                .introText(user.getIntroText())
                .shortIntro(user.getShortIntro())
                .createdAt(DateTimeUtil.convertUTCToKST(user.getCreatedAt()))
                .interests(user.getUserInterests().stream()
                        .map(userInterest -> userInterest.getInterest().getName())
                        .collect(Collectors.toList()))
                .build();
    }

}
