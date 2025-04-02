package com.semothon.spring_server.room.dto;

import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class UpdateRoomRequestDto {
    private String title;
    private String description;
    private Integer capacity;
}
