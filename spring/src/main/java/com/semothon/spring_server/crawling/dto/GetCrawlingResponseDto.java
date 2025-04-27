package com.semothon.spring_server.crawling.dto;

import com.semothon.spring_server.chat.dto.GetChatRoomResponseDto;
import com.semothon.spring_server.crawling.entity.Crawling;
import lombok.*;

import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetCrawlingResponseDto {
    private CrawlingInfoDto crawlingInfo;
    private List<GetChatRoomResponseDto> chatRooms;

    public static GetCrawlingResponseDto from(Crawling crawling){
        return GetCrawlingResponseDto.builder()
                .crawlingInfo(CrawlingInfoDto.from(crawling))
                .chatRooms(crawling.getChatRooms().stream()
                        .map(GetChatRoomResponseDto::from)
                        .collect(Collectors.toList()))
                .build();
    }
}
