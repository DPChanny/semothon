package com.semothon.spring_server.user.dto;

import com.semothon.spring_server.user.entity.User;
import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetUserListResponseDto {
    private UserInfoDto userInfo;

    public static GetUserListResponseDto from(User user){
        return GetUserListResponseDto.builder()
                .userInfo(UserInfoDto.from(user))
                .build();
    }
}
