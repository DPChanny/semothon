package com.semothon.spring_server.chat.dto;

import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class ChatMessageRequestDto {
    private Long chatRoomId;
    private String message;
    private String imageUrl;
}
