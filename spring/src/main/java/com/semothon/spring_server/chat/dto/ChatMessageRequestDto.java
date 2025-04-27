package com.semothon.spring_server.chat.dto;

import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class ChatMessageRequestDto {
    private Long chatRoomId;   // 채팅방 ID
    private String message;    // 텍스트 메시지 내용
    private String imageUrl;   // 이미지 URL (선택)
}
