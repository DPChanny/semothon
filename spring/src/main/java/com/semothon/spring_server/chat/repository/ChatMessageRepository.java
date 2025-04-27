package com.semothon.spring_server.chat.repository;

import com.semothon.spring_server.chat.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long>, ChatMessageRepositoryCustom {
    List<ChatMessage> findAllByChatRoom_ChatRoomIdOrderByCreatedAtAsc(Long chatRoomId);

}
