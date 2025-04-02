package com.semothon.spring_server.user.dto;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import lombok.*;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

// 마지막에 검증 및 테스트 진행

@Getter
@Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
@ToString
public class UserSearchCondition {

    // 키워드 조건
    private String nicknameKeyword;
    private String departmentKeyword;
    private List<String> introKeyword;
    private String nameKeyword;
    private List<String> keyword;


    // 생일 조건
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate birthdateAfter;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate birthdateBefore;

    // 관심사 필터
    private List<String> interestNames;

    // 추천 점수 필터
    private Double minRecommendationScore;
    private Double maxRecommendationScore;

    // 가입일 필터
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime createdAfter;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime createdBefore;

    // 정렬 기준
    @Builder.Default
    private UserSortBy sortBy = UserSortBy.CREATED_AT;

    @Builder.Default
    private UserSortDirection sortDirection = UserSortDirection.DESC;


    // 페이지네이션
    @Min(value = 0, message = "Page must be 0 or greater")
    @Builder.Default
    private Integer page = 0;

    @Min(value = 1, message = "Limit must be at least 1")
    @Max(value = 100, message = "Limit must be at most 100")
    @Builder.Default
    private Integer limit = 10;

    // 유효성 검사 메서드
    @AssertTrue(message = "Birthdate range is invalid")
    public boolean isBirthdateRangeValid() {
        return birthdateAfter == null || birthdateBefore == null || !birthdateAfter.isAfter(birthdateBefore);
    }

    @AssertTrue(message = "Created date range is invalid")
    public boolean isCreatedDateRangeValid() {
        return createdAfter == null || createdBefore == null || !createdAfter.isAfter(createdBefore);
    }
}
