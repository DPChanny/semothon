package com.semothon.spring_server.recommend.dto;

import com.semothon.spring_server.room.entity.Room;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class RecommendRoomResponseDto {
    private Long roomId;
    private String title;
    private String description;
    private int capacity;
    private LocalDateTime createdAt;
    private String hostNickname;
    private Long chatRoomId;
    private int roomUsersCount;

    public static RecommendRoomResponseDto from(Room room) {
        return RecommendRoomResponseDto.builder()
                .roomId(room.getRoomId())
                .title(room.getTitle())
                .description(room.getDescription())
                .capacity(room.getCapacity())
                .createdAt(room.getCreatedAt())
                .hostNickname(room.getHost().getNickname())
                .chatRoomId(room.getChatRoom() != null ? room.getChatRoom().getChatRoomId() : null)
                .roomUsersCount(room.getRoomUsers() != null ? room.getRoomUsers().size() : 0)
                .build();
    }
}
