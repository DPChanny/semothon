package com.semothon.spring_server.chat.repository;

import java.time.LocalDateTime;

public interface ChatMessageRepositoryCustom {
    long countUnreadMessages(Long chatRoomId, LocalDateTime lastReadAt);
}
