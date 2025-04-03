package com.semothon.spring_server.crawling.dto;

import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.crawling.entity.Crawling;
import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class CrawlingInfoDto {
    private Long crawlingId;
    private String title;
    private String url;
    private String imageUrl;
    private String description;
    private LocalDateTime deadlinedAt;
    private LocalDateTime crawledAt;
    private List<Long> chatRoomsId;
    private List<String> interests;


    public static CrawlingInfoDto from(Crawling crawling) {
        return CrawlingInfoDto.builder()
                .crawlingId(crawling.getCrawlingId())
                .title(crawling.getTitle())
                .url(crawling.getUrl())
                .imageUrl(crawling.getImageUrl())
                .description(crawling.getDescription())
                .deadlinedAt(DateTimeUtil.convertUTCToKST(crawling.getDeadlinedAt()))
                .crawledAt(DateTimeUtil.convertUTCToKST(crawling.getCrawledAt()))
                .chatRoomsId(
                        crawling.getChatRooms().stream()
                                .map(ChatRoom::getChatRoomId)
                                .collect(Collectors.toList())
                )
                .interests(
                        crawling.getCrawlingInterests().stream()
                                .map(ci -> ci.getInterest().getName())
                                .collect(Collectors.toList())
                )
                .build();
    }
}
