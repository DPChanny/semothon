package com.semothon.spring_server.chat.dto;

import com.semothon.spring_server.chat.entity.ChatMessage;
import lombok.*;

import java.time.LocalDateTime;
import com.semothon.spring_server.common.service.DateTimeUtil;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class ChatMessageResponseDto {
    private Long chatMessageId;
    private Long chatRoomId;
    private String senderId;
    private String senderNickname;
    private String senderProfileImageUrl;
    private String message;
    private String imageUrl;
    private LocalDateTime createdAt;

    public static ChatMessageResponseDto from(ChatMessage chatMessage) {
        return ChatMessageResponseDto.builder()
                .chatMessageId(chatMessage.getChatMessageId())
                .chatRoomId(chatMessage.getChatRoom().getChatRoomId())
                .senderId(chatMessage.getUser().getUserId())
                .senderNickname(chatMessage.getUser().getNickname())
                .senderProfileImageUrl(chatMessage.getUser().getProfileImageUrl())
                .message(chatMessage.getMessage())
                .imageUrl(chatMessage.getImageUrl())
                .createdAt(DateTimeUtil.convertUTCToKST(chatMessage.getCreatedAt()))
                .build();
    }
}
