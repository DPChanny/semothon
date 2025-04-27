package com.semothon.spring_server.chat.repository;

import com.semothon.spring_server.chat.dto.ChatRoomSearchCondition;
import com.semothon.spring_server.chat.entity.ChatRoom;

import java.time.LocalDateTime;
import java.util.List;

public interface ChatRoomRepositoryCustom {
    List<ChatRoom> searchChatRoomList(ChatRoomSearchCondition condition, String currentUserId);
}
