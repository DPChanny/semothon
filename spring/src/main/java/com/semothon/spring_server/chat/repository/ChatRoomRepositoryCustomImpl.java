package com.semothon.spring_server.chat.repository;

import com.querydsl.core.types.OrderSpecifier;
import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import com.semothon.spring_server.chat.dto.ChatRoomSearchCondition;
import com.semothon.spring_server.chat.dto.ChatRoomSortBy;
import com.semothon.spring_server.chat.dto.ChatRoomSortDirection;
import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.entity.ChatRoomType;
import com.semothon.spring_server.chat.entity.QChatUser;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

import static com.semothon.spring_server.chat.entity.QChatMessage.chatMessage;
import static com.semothon.spring_server.chat.entity.QChatRoom.chatRoom;
import static com.semothon.spring_server.chat.entity.QChatUser.chatUser;
import static com.semothon.spring_server.user.entity.QUser.user;

@Slf4j
@Repository
@RequiredArgsConstructor
public class ChatRoomRepositoryCustomImpl implements ChatRoomRepositoryCustom {

    private final JPAQueryFactory queryFactory;


    @Override
    public List<ChatRoom> searchChatRoomList(ChatRoomSearchCondition condition, String currentUserId) {
        return queryFactory
                .selectFrom(chatRoom)
                .leftJoin(chatRoom.host, user).fetchJoin()
                .leftJoin(chatRoom.chatUsers, chatUser)
                .leftJoin(chatRoom.chatMessages, chatMessage)
                .where(
                        titleKeywordIn(condition.getTitleKeyword()),
                        descriptionKeywordIn(condition.getDescriptionKeyword()),
                        titleOrDescriptionKeywordIn(condition.getTitleOrDescriptionKeyword()),
                        hostUserIdEquals(condition.getHostUserId()),
                        hostNicknameEquals(condition.getHostNickname()),
                        chatRoomTypeEquals(condition.getChatRoomType()),
                        messageKeywordIn(condition.getMessageKeyword()),
                        capacityBetween(condition.getMinCapacity(), condition.getMaxCapacity()),
                        joinedOnly(condition.getJoinedOnly(), currentUserId),
                        excludeJoined(condition.getExcludeJoined(), currentUserId),
                        createdAtBetween(condition.getCreatedAfter(), condition.getCreatedBefore())
                )
                .distinct()
                .orderBy(getOrderSpecifier(condition.getSortBy(), condition.getSortDirection()))
                .offset((long) condition.getPage() * condition.getLimit())
                .limit(condition.getLimit())
                .fetch();
    }

    private BooleanExpression titleKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ? keywords.stream()
                .map(chatRoom.title::containsIgnoreCase)
                .reduce(BooleanExpression::or)
                .orElse(null) : null;
    }

    private BooleanExpression descriptionKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ? keywords.stream()
                .map(chatRoom.description::containsIgnoreCase)
                .reduce(BooleanExpression::or)
                .orElse(null) : null;
    }

    private BooleanExpression titleOrDescriptionKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ? keywords.stream()
                .map(k -> chatRoom.title.containsIgnoreCase(k).or(chatRoom.description.containsIgnoreCase(k)))
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

    private BooleanExpression chatRoomTypeEquals(ChatRoomType chatRoomType) {
        return chatRoomType != null ? chatRoom.type.eq(chatRoomType) : null;
    }

    private BooleanExpression messageKeywordIn(List<String> keywords) {
        return (keywords != null && !keywords.isEmpty()) ? keywords.stream()
                .map(chatMessage.message::containsIgnoreCase)
                .reduce(BooleanExpression::or)
                .orElse(null) : null;
    }

    private BooleanExpression capacityBetween(Integer min, Integer max) {
        if (min != null && max != null) return chatRoom.capacity.between(min, max);
        else if (min != null) return chatRoom.capacity.goe(min);
        else if (max != null) return chatRoom.capacity.loe(max);
        return null;
    }

    private BooleanExpression joinedOnly(boolean joinedOnly, String userId) {
        return joinedOnly ? chatUser.user.userId.eq(userId) : null;
    }

    private BooleanExpression excludeJoined(boolean exclude, String userId) {
        if (!exclude) return null;
        QChatUser subChatUser = new QChatUser("subChatUser");
        return com.querydsl.jpa.JPAExpressions.selectOne()
                .from(subChatUser)
                .where(
                        subChatUser.chatRoom.eq(chatRoom),
                        subChatUser.user.userId.eq(userId)
                )
                .notExists();
    }

    private BooleanExpression createdAtBetween(LocalDateTime start, LocalDateTime end) {
        if (start != null && end != null) return chatRoom.createdAt.between(start, end);
        else if (start != null) return chatRoom.createdAt.goe(start);
        else if (end != null) return chatRoom.createdAt.loe(end);
        return null;
    }

    private OrderSpecifier<?> getOrderSpecifier(ChatRoomSortBy sortBy, ChatRoomSortDirection direction) {
        return switch (sortBy) {
            case CREATED_AT -> direction == ChatRoomSortDirection.ASC ? chatRoom.createdAt.asc() : chatRoom.createdAt.desc();
            case CAPACITY -> direction == ChatRoomSortDirection.ASC ? chatRoom.capacity.asc() : chatRoom.capacity.desc();
            case CURRENT_MEMBERS -> direction == ChatRoomSortDirection.ASC ? chatRoom.chatUsers.size().asc() : chatRoom.chatUsers.size().desc();
        };
    }
}
