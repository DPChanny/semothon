package com.semothon.spring_server.room.dto;

public enum RoomSortBy {
    CREATED_AT("createdAt"),                // 생성일 기준
    CAPACITY("capacity"),                   // 그룹 정원
    CURRENT_MEMBERS("currentMembers"),      // 현재 참여 인원 수
    SCORE("score");                         // 추천 점수

    private final String value;

    RoomSortBy(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
