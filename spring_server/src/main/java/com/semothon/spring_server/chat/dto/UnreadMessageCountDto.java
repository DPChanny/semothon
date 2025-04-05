package com.semothon.spring_server.chat.dto;

import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class UnreadMessageCountDto {
    Long chatRoomId;
    Long unreadCount;
}
