package com.semothon.spring_server.chat.dto;

import com.semothon.spring_server.chat.entity.ChatUser;
import com.semothon.spring_server.chat.entity.ChatUserRole;
import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.user.entity.User;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class ChatUserInfoDto {
    private String userId;
    private String nickname;
    private String profileImageUrl;
    private String shortIntro;
    private ChatUserRole role;
    private LocalDateTime joinedAt;
    private LocalDateTime lastReadAt;

    public static ChatUserInfoDto from(ChatUser chatUser) {
        User user = chatUser.getUser();

        return ChatUserInfoDto.builder()
                .userId(user.getUserId())
                .nickname(user.getNickname())
                .profileImageUrl(user.getProfileImageUrl())
                .shortIntro(user.getShortIntro())
                .role(chatUser.getRole())
                .joinedAt(DateTimeUtil.convertUTCToKST(chatUser.getJoinedAt()))
                .lastReadAt(chatUser.getLastReadAt())
                .build();
    }

}
