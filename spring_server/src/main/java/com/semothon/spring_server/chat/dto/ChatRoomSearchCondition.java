package com.semothon.spring_server.chat.dto;

import com.semothon.spring_server.chat.entity.ChatRoomType;
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
public class ChatRoomSearchCondition {

    // 제목/설명 키워드 검색
    private List<String> titleKeyword;
    private List<String> descriptionKeyword;
    private List<String> titleOrDescriptionKeyword;

    // 방장 정보
    private String hostUserId;
    private String hostNickname;

    // 채팅방 유형 (예: ROOM, CRAWLING)
    private ChatRoomType chatRoomType;

    // 메시지 키워드 검색
    private List<String> messageKeyword;

    // 정원 조건
    private Integer minCapacity;
    private Integer maxCapacity;

    @Builder.Default
    private Boolean joinedOnly = false;

    @Builder.Default
    private Boolean excludeJoined = false;

    // 생성일 조건
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime createdAfter;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    private LocalDateTime createdBefore;

    // 정렬 조건
    @Builder.Default
    private ChatRoomSortBy sortBy = ChatRoomSortBy.CREATED_AT;

    @Builder.Default
    private ChatRoomSortDirection sortDirection = ChatRoomSortDirection.DESC;

    // 페이지네이션
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