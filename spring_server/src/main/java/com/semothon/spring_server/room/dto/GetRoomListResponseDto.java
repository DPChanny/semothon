package com.semothon.spring_server.room.dto;

import com.semothon.spring_server.room.entity.Room;
import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetRoomListResponseDto {
    private RoomInfoDto room;
    private HostUserInfoDto host;

    public static GetRoomListResponseDto from(Room room){
        return GetRoomListResponseDto.builder()
                .room(RoomInfoDto.from(room))
                .host(HostUserInfoDto.from(room.getHost()))
                .build();
    }
}
