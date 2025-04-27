package com.semothon.spring_server.chat.repository;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

import static com.semothon.spring_server.chat.entity.QChatMessage.chatMessage;

@Repository
@RequiredArgsConstructor
public class ChatMessageRepositoryCustomImpl implements ChatMessageRepositoryCustom{

    private final JPAQueryFactory queryFactory;

    @Override
    public long countUnreadMessages(Long chatRoomId, LocalDateTime lastReadAt) {
        Long count = queryFactory
                .select(chatMessage.count())
                .from(chatMessage)
                .where(
                        chatMessage.chatRoom.chatRoomId.eq(chatRoomId),
                        afterLastRead(lastReadAt)
                )
                .fetchOne();
        return count;
    }

    private BooleanExpression afterLastRead(LocalDateTime lastReadAt) {
        return lastReadAt != null ? chatMessage.createdAt.gt(lastReadAt) : null;
    }
}
