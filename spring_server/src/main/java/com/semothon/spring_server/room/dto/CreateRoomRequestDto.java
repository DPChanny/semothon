package com.semothon.spring_server.room.dto;

import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class CreateRoomRequestDto {
    private String title;

    private String description;

    private int capacity;
}
