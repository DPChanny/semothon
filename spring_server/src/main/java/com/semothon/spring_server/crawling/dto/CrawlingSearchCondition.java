package com.semothon.spring_server.crawling.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString
public class CrawlingSearchCondition {
    // 키워드 검색
    private List<String> titleKeyword;
    private List<String> descriptionKeyword;
    private List<String> titleOrDescriptionKeyword;

    // 관심사 필터링
    private List<String> interestNames;


    // 발행일 필터
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime deadlinedAfter;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime deadlinedBefore;

    // 크롤링 일시 필터
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime crawledAfter;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime crawledBefore;

    // 사용자 기반 추천 점수 범위 필터
    private Double minRecommendationScore;
    private Double maxRecommendationScore;

    @Builder.Default
    private CrawlingSortBy sortBy = CrawlingSortBy.CRAWLED_AT;

    @Builder.Default
    private CrawlingSortDirection sortDirection = CrawlingSortDirection.DESC;

    @Min(value = 0, message = "Page value cannot be negative")
    @Builder.Default
    private Integer page = 0;

    @Min(value = 1, message = "Page size must be at least 1")
    @Max(value = 100, message = "Page size must be at most 100")
    @Builder.Default
    private Integer limit = 10;
}
