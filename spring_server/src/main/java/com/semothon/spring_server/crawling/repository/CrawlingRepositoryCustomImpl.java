package com.semothon.spring_server.crawling.repository;

import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.Projections;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.semothon.spring_server.crawling.dto.CrawlingSearchCondition;
import com.semothon.spring_server.crawling.dto.CrawlingSortBy;
import com.semothon.spring_server.crawling.dto.CrawlingSortDirection;
import com.semothon.spring_server.crawling.dto.CrawlingWithScoreDto;
import com.semothon.spring_server.crawling.entity.Crawling;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.stream.Collectors;

import static com.semothon.spring_server.crawling.entity.QCrawling.crawling;
import static com.semothon.spring_server.crawling.entity.QCrawlingInterest.crawlingInterest;
import static com.semothon.spring_server.crawling.entity.QUserCrawlingRecommendation.userCrawlingRecommendation;
import static com.semothon.spring_server.interest.entity.QInterest.interest;

@Slf4j
@Repository
@RequiredArgsConstructor
public class CrawlingRepositoryCustomImpl implements CrawlingRepositoryCustom {

    private final JPAQueryFactory queryFactory;

    @Override
    public List<CrawlingWithScoreDto> searchCrawlingList(CrawlingSearchCondition condition, String currentUserId) {
        List<CrawlingWithScoreDto> results = queryFactory
                .select(Projections.constructor(CrawlingWithScoreDto.class, crawling, userCrawlingRecommendation.score))
                .from(crawling)
                .leftJoin(crawling.crawlingInterests, crawlingInterest)
                .leftJoin(crawlingInterest.interest, interest)
                .leftJoin(crawling.userCrawlingRecommendations, userCrawlingRecommendation)
                .on(userCrawlingRecommendation.user.userId.eq(currentUserId))
                .where(
                        titleKeywordIn(condition.getTitleKeyword()),
                        descriptionKeywordIn(condition.getDescriptionKeyword()),
                        titleOrDescriptionKeywordIn(condition.getTitleOrDescriptionKeyword()),
                        interestIn(condition.getInterestNames()),
                        deadlinedBetween(condition.getDeadlinedAfter(), condition.getDeadlinedBefore()),
                        crawledBetween(condition.getCrawledAfter(), condition.getCrawledBefore()),
                        recommendationScoreBetween(condition.getMinRecommendationScore(), condition.getMaxRecommendationScore())
                )
                .distinct()
                .orderBy(getOrderSpecifier(condition.getSortBy(), condition.getSortDirection()))
                .offset((long) condition.getPage() * condition.getLimit())
                .limit(condition.getLimit())
                .fetch();

        List<CrawlingWithScoreDto> deduplicated = results.stream()
                .collect(Collectors.collectingAndThen(
                        Collectors.toMap(
                                dto -> dto.crawling().getCrawlingId(),
                                dto -> dto,
                                (existing, replacement) -> existing,
                                LinkedHashMap::new
                        ),
                        m -> new ArrayList<>(m.values())
                ));

        return deduplicated;
    }

    private BooleanExpression titleKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ?
                keywords.stream()
                        .map(crawling.title::containsIgnoreCase)
                        .reduce(BooleanExpression::or)
                        .orElse(null) : null;
    }

    private BooleanExpression descriptionKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ?
                keywords.stream()
                        .map(crawling.description::containsIgnoreCase)
                        .reduce(BooleanExpression::or)
                        .orElse(null) : null;
    }

    private BooleanExpression titleOrDescriptionKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ?
                keywords.stream()
                        .map(k -> crawling.title.containsIgnoreCase(k).or(crawling.description.containsIgnoreCase(k)))
                        .reduce(BooleanExpression::or)
                        .orElse(null) : null;
    }

    private BooleanExpression interestIn(List<String> names) {
        return (names != null && !names.isEmpty()) ? interest.name.in(names) : null;
    }

    private BooleanExpression deadlinedBetween(LocalDateTime start, LocalDateTime end) {
        if (start != null && end != null) return crawling.deadlinedAt.between(start, end);
        else if (start != null) return crawling.deadlinedAt.goe(start);
        else if (end != null) return crawling.deadlinedAt.loe(end);
        return null;
    }

    private BooleanExpression crawledBetween(LocalDateTime start, LocalDateTime end) {
        if (start != null && end != null) return crawling.crawledAt.between(start, end);
        else if (start != null) return crawling.crawledAt.goe(start);
        else if (end != null) return crawling.crawledAt.loe(end);
        return null;
    }

    private BooleanExpression recommendationScoreBetween(Double min, Double max) {
        if (min != null && max != null) return userCrawlingRecommendation.score.between(min, max);
        else if (min != null) return userCrawlingRecommendation.score.goe(min);
        else if (max != null) return userCrawlingRecommendation.score.loe(max);
        return null;
    }

    private OrderSpecifier<?> getOrderSpecifier(CrawlingSortBy sortBy, CrawlingSortDirection direction) {
        return switch (sortBy) {
            case CRAWLED_AT -> direction == CrawlingSortDirection.ASC ? crawling.crawledAt.asc() : crawling.crawledAt.desc();
            case DEADLINED_AT -> direction == CrawlingSortDirection.ASC ? crawling.deadlinedAt.asc() : crawling.deadlinedAt.desc();
            case SCORE -> direction == CrawlingSortDirection.ASC ? userCrawlingRecommendation.score.asc() : userCrawlingRecommendation.score.desc();
        };
    }
}
