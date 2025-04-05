package com.semothon.spring_server.crawling.dto;

import com.semothon.spring_server.common.service.ScoreNormalization;
import com.semothon.spring_server.crawling.entity.Crawling;
import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class GetCrawlingListResponseDto {
    private CrawlingInfoDto crawlingInfo;
    private Double score;

    public static GetCrawlingListResponseDto from(Crawling crawling, Double score){
        return GetCrawlingListResponseDto.builder()
                .crawlingInfo(CrawlingInfoDto.from(crawling))
                .score(ScoreNormalization.normalize(score))
                .build();
    }
}