package com.semothon.spring_server.room.repository;

import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.semothon.spring_server.room.dto.RoomSearchCondition;
import com.semothon.spring_server.room.dto.RoomSortBy;
import com.semothon.spring_server.room.dto.RoomSortDirection;
import com.semothon.spring_server.room.dto.RoomWithScoreDto;
import com.semothon.spring_server.room.entity.QRoomUser;
import com.semothon.spring_server.room.entity.Room;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.stream.Collectors;

import static com.semothon.spring_server.interest.entity.QInterest.interest;
import static com.semothon.spring_server.room.entity.QRoom.room;
import static com.semothon.spring_server.room.entity.QRoomInterest.roomInterest;
import static com.semothon.spring_server.room.entity.QRoomUser.roomUser;
import static com.semothon.spring_server.room.entity.QUserRoomRecommendation.userRoomRecommendation;
import static com.semothon.spring_server.user.entity.QUser.user;

@Slf4j
@Repository
@RequiredArgsConstructor
public class RoomRepositoryCustomImpl implements RoomRepositoryCustom{

    private final JPAQueryFactory queryFactory;
    @Override
    public List<RoomWithScoreDto> searchRoomList(RoomSearchCondition condition, String currentUserId) {
        List<RoomWithScoreDto> rawResults = queryFactory
                .select(Projections.constructor(RoomWithScoreDto.class, room, userRoomRecommendation.score))
                .from(room)
                .leftJoin(room.host, user).fetchJoin()
                .leftJoin(room.roomUsers, roomUser)
                .leftJoin(room.roomInterests, roomInterest)
                .leftJoin(roomInterest.interest, interest)
                .leftJoin(room.userRoomRecommendations, userRoomRecommendation)
                .on(userRoomRecommendation.user.userId.eq(currentUserId))
                .where(
                        titleKeywordIn(condition.getTitleKeyword()),
                        descriptionKeywordIn(condition.getDescriptionKeyword()),
                        titleOrDescriptionKeywordIn(condition.getTitleOrDescriptionKeyword()),
                        hostUserIdEquals(condition.getHostUserId()),
                        hostNicknameEquals(condition.getHostNickname()),
                        interestIn(condition.getInterestNames()),
                        capacityBetween(condition.getMinCapacity(), condition.getMaxCapacity()),
                        recommendationScoreBetween(condition.getMinRecommendationScore(), condition.getMaxRecommendationScore()),
                        joinedOnly(condition.getJoinedOnly(), currentUserId),
                        excludeJoined(condition.getExcludeJoined(), currentUserId),
                        createdAtBetween(condition.getCreatedAfter(), condition.getCreatedBefore())
                )
                .distinct()
                .orderBy(getOrderSpecifier(condition.getSortBy(), condition.getSortDirection()))
                .offset((long) condition.getPage() * condition.getLimit())
                .limit(condition.getLimit())
                .fetch();

        // ✅ roomId 기준 중복 제거
        List<RoomWithScoreDto> deduplicated = rawResults.stream()
                .collect(Collectors.collectingAndThen(
                        Collectors.toMap(
                                dto -> dto.room().getRoomId(),
                                dto -> dto,
                                (existing, replacement) -> existing,
                                LinkedHashMap::new
                        ),
                        m -> new ArrayList<>(m.values())
                ));

        return deduplicated;
    }

    private BooleanExpression titleKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ? keywords.stream()
                .map(room.title::containsIgnoreCase)
                .reduce(BooleanExpression::or)
                .orElse(null) : null;
    }

    private BooleanExpression descriptionKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ? keywords.stream()
                .map(room.description::containsIgnoreCase)
                .reduce(BooleanExpression::or)
                .orElse(null) : null;
    }

    private BooleanExpression titleOrDescriptionKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ? keywords.stream()
                .map(k -> room.title.containsIgnoreCase(k).or(room.description.containsIgnoreCase(k)))
                .reduce(BooleanExpression::or)
                .orElse(null) : null;
    }

    private BooleanExpression hostUserIdEquals(String hostUserId) {
        return (hostUserId != null) ? user.userId.eq(hostUserId) : null;
    }

    private BooleanExpression hostNicknameEquals(String nickname) {
        return (nickname != null && !nickname.isBlank())
                ? user.nickname.containsIgnoreCase(nickname)
                : null;
    }

    private BooleanExpression interestIn(List<String> names) {
        return (names != null && !names.isEmpty()) ? interest.name.in(names) : null;
    }

    private BooleanExpression capacityBetween(Integer min, Integer max) {
        if (min != null && max != null) return room.capacity.between(min, max);
        else if (min != null) return room.capacity.goe(min);
        else if (max != null) return room.capacity.loe(max);
        return null;
    }

    private BooleanExpression recommendationScoreBetween(Double min, Double max) {
        if (min != null && max != null) return userRoomRecommendation.score.between(min, max);
        else if (min != null) return userRoomRecommendation.score.goe(min);
        else if (max != null) return userRoomRecommendation.score.loe(max);
        return null;
    }

    private BooleanExpression joinedOnly(boolean joinedOnly, String userId) {
        return joinedOnly ? roomUser.user.userId.eq(userId) : null;
    }

    private BooleanExpression excludeJoined(boolean exclude, String userId) {
        if (!exclude) return null;

        QRoomUser subRoomUser = new QRoomUser("subRoomUser");

        return JPAExpressions.selectOne()
                .from(subRoomUser)
                .where(
                        subRoomUser.room.eq(room),
                        subRoomUser.user.userId.eq(userId)
                )
                .notExists();
    }

    private BooleanExpression createdAtBetween(LocalDateTime start, LocalDateTime end) {
        if (start != null && end != null) return room.createdAt.between(start, end);
        else if (start != null) return room.createdAt.goe(start);
        else if (end != null) return room.createdAt.loe(end);
        return null;
    }

    private OrderSpecifier<?> getOrderSpecifier(RoomSortBy sortBy, RoomSortDirection direction) {
        return switch (sortBy) {
            case CREATED_AT -> direction == RoomSortDirection.ASC ? room.createdAt.asc() : room.createdAt.desc();
            case CAPACITY -> direction == RoomSortDirection.ASC ? room.capacity.asc() : room.capacity.desc();
            case CURRENT_MEMBERS -> direction == RoomSortDirection.ASC ? room.roomUsers.size().asc() : room.roomUsers.size().desc();
            case SCORE -> direction == RoomSortDirection.ASC ? userRoomRecommendation.score.asc() : userRoomRecommendation.score.desc();
        };
    }
}
