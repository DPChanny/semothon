package com.semothon.spring_server.chat.dto;

import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class UpdateChatRoomRequestDto {
    private String title;
    private String description;
    private Integer capacity;
}
