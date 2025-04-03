package com.semothon.spring_server.chat.dto;

import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.entity.ChatRoomType;
import com.semothon.spring_server.room.dto.HostUserInfoDto;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetChatRoomResponseDto {
    private ChatRoomInfoDto chatRoomInfo;
    private HostUserInfoDto host;
    private List<ChatUserInfoDto> members;

    public static GetChatRoomResponseDto from(ChatRoom chatRoom) {
        return GetChatRoomResponseDto.builder()
                .chatRoomInfo(ChatRoomInfoDto.from(chatRoom))
                .host(HostUserInfoDto.from(chatRoom.getHost()))
                .members(chatRoom.getChatUsers().stream()
                        .map(ChatUserInfoDto::from)
                        .collect(Collectors.toList()))
                .build();
    }


}
