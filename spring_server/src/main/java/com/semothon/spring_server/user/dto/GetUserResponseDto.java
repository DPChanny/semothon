package com.semothon.spring_server.user.dto;

import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.user.entity.Gender;
import com.semothon.spring_server.user.entity.User;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetUserResponseDto {

    private String userId;
    private String nickname;
    private String department;
    private String studentId;
    private LocalDate birthdate;
    private Gender gender;
    private String profileImageUrl;
    private String socialProvider;
    private String socialId;
    private String introText;
    private LocalDateTime createdAt;

    public static GetUserResponseDto from(User user) {
        return GetUserResponseDto.builder()
                .userId(user.getUserId())
                .nickname(user.getNickname())
                .department(user.getDepartment())
                .studentId(user.getStudentId())
                .birthdate(user.getBirthdate())
                .gender(user.getGender())
                .profileImageUrl(user.getProfileImageUrl())
                .socialProvider(user.getSocialProvider())
                .socialId(user.getSocialId())
                .introText(user.getIntroText())
                .createdAt(DateTimeUtil.convertUTCToKST(user.getCreatedAt()))
                .build();
    }

}
