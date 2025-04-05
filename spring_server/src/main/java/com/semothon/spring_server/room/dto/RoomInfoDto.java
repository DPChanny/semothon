package com.semothon.spring_server.room.dto;

import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.room.entity.Room;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class RoomInfoDto {
    private Long roomId;
    private String title;
    private String description;
    private Integer capacity;
    private LocalDateTime createdAt;
    private Integer currentMemberCount;
    private Long chatRoomId;
    private List<String> interests;
    private String profileImageUrl;

    public static RoomInfoDto from(Room room){
        return RoomInfoDto.builder()
                .roomId(room.getRoomId())
                .title(room.getTitle())
                .description(room.getDescription())
                .capacity(room.getCapacity())
                .createdAt(DateTimeUtil.convertUTCToKST(room.getCreatedAt()))
                .currentMemberCount(room.getRoomUsers() != null ? room.getRoomUsers().size() : 0)
                .chatRoomId(room.getChatRoom() != null ? room.getChatRoom().getChatRoomId() : null)
                .interests(room.getRoomInterests().stream()
                        .map(roomInterest -> roomInterest.getInterest().getName())
                        .collect(Collectors.toList()))
                .profileImageUrl(room.getHost().getProfileImageUrl())
                .build();
    }
}
