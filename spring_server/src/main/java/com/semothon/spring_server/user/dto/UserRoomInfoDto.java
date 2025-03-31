package com.semothon.spring_server.user.dto;

import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.room.entity.RoomUser;
import com.semothon.spring_server.room.entity.RoomUserRole;
import com.semothon.spring_server.user.entity.User;
import lombok.*;

import java.time.LocalDateTime;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class UserRoomInfoDto {
    private Long roomId;
    private RoomUserRole role;
    private LocalDateTime joinedAt;

    private String title;
    private String hostUserId;

    public static UserRoomInfoDto from(RoomUser roomUser){
        Room room = roomUser.getRoom();

        return UserRoomInfoDto.builder()
                .roomId(room.getRoomId())
                .role(roomUser.getRole())
                .joinedAt(roomUser.getJoinedAt())
                .title(room.getTitle())
                .hostUserId(room.getHost().getUserId())
                .build();

    }
}
