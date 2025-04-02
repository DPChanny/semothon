package com.semothon.spring_server.chat.dto;

import com.semothon.spring_server.chat.entity.ChatMessage;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class ChatMessageResponseDto {
    private Long chatMessageId;
    private Long chatRoomId;
    private String userId;
    private String message;
    private String imageUrl;
    private LocalDateTime createdAt;

    public static ChatMessageResponseDto from(ChatMessage chatMessage) {
        return ChatMessageResponseDto.builder()
                .chatMessageId(chatMessage.getChatMessageId())
                .chatRoomId(chatMessage.getChatRoom().getChatRoomId())
                .userId(chatMessage.getUser().getUserId())
                .message(chatMessage.getMessage())
                .imageUrl(chatMessage.getImageUrl())
                .createdAt(chatMessage.getCreatedAt())
                .build();
    }
}
