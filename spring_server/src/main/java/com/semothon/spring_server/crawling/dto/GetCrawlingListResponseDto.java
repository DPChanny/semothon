package com.semothon.spring_server.crawling.dto;

import com.semothon.spring_server.crawling.entity.Crawling;
import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetCrawlingListResponseDto {
    private CrawlingInfoDto crawlingInfo;

    public static GetCrawlingListResponseDto from(Crawling crawling){
        return GetCrawlingListResponseDto.builder()
                .crawlingInfo(CrawlingInfoDto.from(crawling))
                .build();
    }
}