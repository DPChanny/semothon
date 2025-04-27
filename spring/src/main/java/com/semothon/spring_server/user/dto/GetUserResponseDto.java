package com.semothon.spring_server.user.dto;

import com.semothon.spring_server.chat.dto.ChatRoomInfoDto;
import com.semothon.spring_server.chat.dto.ChatUserInfoDto;
import com.semothon.spring_server.chat.entity.ChatUser;
import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.user.entity.Gender;
import com.semothon.spring_server.user.entity.User;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetUserResponseDto {
    private UserInfoDto userInfo;
    private List<UserRoomInfoDto> rooms;
    private List<ChatRoomInfoDto> chatRooms;

    public static GetUserResponseDto from(User user){
        return GetUserResponseDto.builder()
                .userInfo(UserInfoDto.from(user))
                .rooms(user.getRoomUsers().stream()
                        .map(UserRoomInfoDto::from)
                        .collect(Collectors.toList()))
                .chatRooms(user.getChatUsers().stream()
                        .map(ChatUser::getChatRoom)
                        .map(ChatRoomInfoDto::from)
                        .collect(Collectors.toList()))
                .build();
    }
}
