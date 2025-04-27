package com.semothon.spring_server.chat.dto;

import com.semothon.spring_server.chat.entity.ChatMessage;
import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.entity.ChatRoomType;
import com.semothon.spring_server.common.service.DateTimeUtil;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class ChatRoomInfoDto {
    private Long chatRoomId;
    private ChatRoomType type;
    private String title;
    private String description;
    private Integer capacity;
    private Long roomId;
    private Long crawlingId;
    private Integer currentMemberCount;
    private LocalDateTime createdAt;
    private String profileImageUrl;
    private String hostUserId;
    private ChatMessageResponseDto lastMessage;

    public static ChatRoomInfoDto from(ChatRoom chatRoom) {
        return ChatRoomInfoDto.builder()
                .chatRoomId(chatRoom.getChatRoomId())
                .type(chatRoom.getType())
                .title(chatRoom.getTitle())
                .description(chatRoom.getDescription())
                .capacity(chatRoom.getCapacity())
                .currentMemberCount(chatRoom.getChatUsers() != null ? chatRoom.getChatUsers().size() : 0)
                .roomId(chatRoom.getRoom() != null ? chatRoom.getRoom().getRoomId() : null)
                .crawlingId(chatRoom.getCrawling() != null ? chatRoom.getCrawling().getCrawlingId() : null)
                .createdAt(DateTimeUtil.convertUTCToKST(chatRoom.getCreatedAt()))
                .profileImageUrl(chatRoom.getHost().getProfileImageUrl())
                .hostUserId(chatRoom.getHost().getUserId())
                .lastMessage(getLastMessage(chatRoom))
                .build();
    }

    private static ChatMessageResponseDto getLastMessage(ChatRoom chatRoom) {
        if (chatRoom.getChatMessages() == null || chatRoom.getChatMessages().isEmpty()) {
            return null;
        }

        ChatMessage last = chatRoom.getChatMessages()
                .stream()
                .max((m1, m2) -> m1.getCreatedAt().compareTo(m2.getCreatedAt()))
                .orElse(null);

        return last != null ? ChatMessageResponseDto.from(last) : null;
    }
}
