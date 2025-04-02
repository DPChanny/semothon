package com.semothon.spring_server.chat.repository;

import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.entity.ChatUser;
import com.semothon.spring_server.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatUserRepository extends JpaRepository<ChatUser, Long> {
    boolean existsByChatRoomAndUser(ChatRoom chatRoom, User user);

}
