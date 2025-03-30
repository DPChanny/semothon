package com.semothon.spring_server.room.dto;

import jakarta.validation.constraints.AssertTrue;
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
public class RoomSearchCondition {

    // 제목/설명 키워드 검색
    private List<String> titleKeyword;
    private List<String> descriptionKeyword;
    private List<String> titleOrDescriptionKeyword;

    // 방장 정보
    private String hostUserId;         // 방장 ID
    private String hostNickname;       // 방장 닉네임

    // 관심사 기반 필터
    private List<String> interestNames; // 관심사 이름 리스트 (ex: "인공지능", "문화") → 내부에서 interestId로 변환 후 쿼리

    private Integer minCapacity;
    private Integer maxCapacity;

    // 추천 점수 조건 (User 기반)
    private Double minRecommendationScore;
    private Double maxRecommendationScore;

    @Builder.Default
    private Boolean joinedOnly = false;     // 내가 참여 중인 그룹만
    @Builder.Default
    private Boolean excludeJoined = false;  // 내가 참여하지 않은 그룹만


    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime createdAfter;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime createdBefore;


    @Builder.Default
    private RoomSortBy sortBy = RoomSortBy.CREATED_AT;
    @Builder.Default
    private RoomSortDirection sortDirection = RoomSortDirection.DESC;

    @Min(value = 0, message = "Page value cannot be negative")
    @Builder.Default
    private Integer page = 0;

    @Min(value = 1, message = "Page size must be at least 1")
    @Max(value = 100, message = "Page size must be at most 100")
    @Builder.Default
    private Integer limit = 10;

    @AssertTrue(message = "Start date cannot be after end date")
    public boolean isDateRangeValid() {
        return createdAfter == null || createdBefore == null || !createdAfter.isAfter(createdBefore);
    }

    @AssertTrue(message = "'joinedOnly' and 'excludeJoined' cannot be both true")
    public boolean isJoinedConditionValid() {
        return !(Boolean.TRUE.equals(joinedOnly) && Boolean.TRUE.equals(excludeJoined));
    }
}
