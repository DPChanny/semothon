package com.semothon.spring_server.room.dto;

import com.semothon.spring_server.room.entity.RoomUserRole;
import com.semothon.spring_server.user.entity.User;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class HostUserInfoDto {
    private String userId;
    private String nickname;
    private String profileImageUrl;
    private String shortIntro;

    public static HostUserInfoDto from(User user){
        return HostUserInfoDto.builder()
                .userId(user.getUserId())
                .nickname(user.getNickname())
                .profileImageUrl(user.getProfileImageUrl())
                .shortIntro(user.getShortIntro())
                .build();
    }
}
