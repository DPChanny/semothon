package com.semothon.spring_server.room.dto;

import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.room.entity.RoomUser;
import com.semothon.spring_server.room.entity.RoomUserRole;
import com.semothon.spring_server.user.entity.User;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class RoomUserInfoDto {
    private String userId;
    private String nickname;
    private String profileImageUrl;
    private String shortIntro;
    private RoomUserRole role;
    private LocalDateTime joinedAt;

    public static RoomUserInfoDto from(RoomUser roomUser){
        User user = roomUser.getUser();

        return RoomUserInfoDto.builder()
                .userId(user.getUserId())
                .nickname(user.getNickname())
                .profileImageUrl(user.getProfileImageUrl())
                .shortIntro(user.getShortIntro())
                .role(roomUser.getRole())
                .joinedAt(DateTimeUtil.convertUTCToKST(roomUser.getJoinedAt()))
                .build();
    }
}
