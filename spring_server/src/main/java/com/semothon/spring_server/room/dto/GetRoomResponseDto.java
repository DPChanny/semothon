package com.semothon.spring_server.room.dto;

import com.semothon.spring_server.room.entity.Room;
import lombok.*;

import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetRoomResponseDto {
    private RoomInfoDto roomInfo;
    private List<RoomUserInfoDto> members;
    private HostUserInfoDto host;

    public static GetRoomResponseDto from(Room room){
        return GetRoomResponseDto.builder()
                .roomInfo(RoomInfoDto.from(room))
                .members(room.getRoomUsers().stream()
                        .map(RoomUserInfoDto::from)
                        .collect(Collectors.toList()))
                .host(HostUserInfoDto.from(room.getHost()))
                .build();
    }
}
