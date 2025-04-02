package com.semothon.spring_server.chat.dto;

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
                .build();
    }
}
