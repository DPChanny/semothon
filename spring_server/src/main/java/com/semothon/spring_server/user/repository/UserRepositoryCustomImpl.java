package com.semothon.spring_server.user.repository;

import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.semothon.spring_server.user.dto.UserSearchCondition;
import com.semothon.spring_server.user.dto.UserSortBy;
import com.semothon.spring_server.user.dto.UserSortDirection;
import com.semothon.spring_server.user.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

import static com.semothon.spring_server.interest.entity.QInterest.interest;
import static com.semothon.spring_server.room.entity.QRoomUser.roomUser;
import static com.semothon.spring_server.room.entity.QUserRoomRecommendation.userRoomRecommendation;
import static com.semothon.spring_server.user.entity.QUser.user;
import static com.semothon.spring_server.user.entity.QUserInterest.userInterest;

@Slf4j
@Repository
@RequiredArgsConstructor
public class UserRepositoryCustomImpl implements UserRepositoryCustom{

    private final JPAQueryFactory queryFactory;

    @Override
    public List<User> searchUserList(UserSearchCondition condition, String currentUserId) {
        return queryFactory.selectDistinct(user)
                .from(user)
                .leftJoin(user.userInterests, userInterest).leftJoin(userInterest.interest, interest)
                .leftJoin(user.roomUsers, roomUser)
                .leftJoin(userRoomRecommendation).on(userRoomRecommendation.user.eq(user))
                .where(
                        nicknameContains(condition.getNicknameKeyword()),
                        departmentEquals(condition.getDepartmentKeyword()),
                        nameContains(condition.getNameKeyword()),
                        introContainsAny(condition.getIntroKeyword()),
                        keywordSearch(condition.getKeyword()),
                        birthdateBetween(condition.getBirthdateAfter(), condition.getBirthdateBefore()),
                        createdAtBetween(condition.getCreatedAfter(), condition.getCreatedBefore()),
                        interestIn(condition.getInterestNames()),
                        recommendationScoreBetween(condition.getMinRecommendationScore(), condition.getMaxRecommendationScore())
                )
                .orderBy(getOrderSpecifier(condition.getSortBy(), condition.getSortDirection()))
                .offset((long) condition.getPage() * condition.getLimit())
                .limit(condition.getLimit())
                .fetch();

    }

    private BooleanExpression nicknameContains(String keyword) {
        return keyword != null ? user.nickname.containsIgnoreCase(keyword) : null;
    }

    private BooleanExpression departmentEquals(String keyword) {
        return keyword != null ? user.department.eq(keyword) : null;
    }

    private BooleanExpression nameContains(String keyword) {
        return keyword != null ? user.name.containsIgnoreCase(keyword) : null;
    }

    private BooleanExpression introContainsAny(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ? keywords.stream()
                .map(k -> user.introText.containsIgnoreCase(k).or(user.shortIntro.containsIgnoreCase(k)))
                .reduce(BooleanExpression::or).orElse(null) : null;
    }

    private BooleanExpression keywordSearch(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ? keywords.stream()
                .map(k -> user.nickname.containsIgnoreCase(k)
                        .or(user.name.containsIgnoreCase(k))
                        .or(user.department.containsIgnoreCase(k))
                        .or(user.introText.containsIgnoreCase(k))
                        .or(user.shortIntro.containsIgnoreCase(k)))
                .reduce(BooleanExpression::or).orElse(null) : null;
    }

    private BooleanExpression birthdateBetween(LocalDate after, LocalDate before) {
        if (after != null && before != null) return user.birthdate.between(after, before);
        else if (after != null) return user.birthdate.goe(after);
        else if (before != null) return user.birthdate.loe(before);
        return null;
    }

    private BooleanExpression createdAtBetween(LocalDateTime after, LocalDateTime before) {
        if (after != null && before != null) return user.createdAt.between(after, before);
        else if (after != null) return user.createdAt.goe(after);
        else if (before != null) return user.createdAt.loe(before);
        return null;
    }

    private BooleanExpression interestIn(List<String> interestNames) {
        return (interestNames != null && !interestNames.isEmpty()) ? interest.name.in(interestNames) : null;
    }

    private BooleanExpression recommendationScoreBetween(Double min, Double max) {
        if (min != null && max != null) return userRoomRecommendation.score.between(min, max);
        else if (min != null) return userRoomRecommendation.score.goe(min);
        else if (max != null) return userRoomRecommendation.score.loe(max);
        return null;
    }

    private OrderSpecifier<?> getOrderSpecifier(UserSortBy sortBy, UserSortDirection direction) {
        return switch (sortBy) {
            case CREATE_AT -> direction == UserSortDirection.ASC ? user.createdAt.asc() : user.createdAt.desc();
            case SCORE -> direction == UserSortDirection.ASC ? userRoomRecommendation.score.asc() : userRoomRecommendation.score.desc();
        };
    }
}
