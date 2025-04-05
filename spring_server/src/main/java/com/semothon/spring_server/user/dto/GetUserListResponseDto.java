package com.semothon.spring_server.user.dto;

import com.semothon.spring_server.common.service.ScoreNormalization;
import com.semothon.spring_server.user.entity.User;
import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetUserListResponseDto {
    private UserInfoDto userInfo;
    private Double score;

    public static GetUserListResponseDto from(User user, Double score){
        return GetUserListResponseDto.builder()
                .userInfo(UserInfoDto.from(user))
                .score(ScoreNormalization.normalize(score))
                .build();
    }
}
