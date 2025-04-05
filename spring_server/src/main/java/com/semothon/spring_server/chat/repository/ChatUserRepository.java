package com.semothon.spring_server.chat.repository;

import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.entity.ChatUser;
import com.semothon.spring_server.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChatUserRepository extends JpaRepository<ChatUser, Long> {
    boolean existsByChatRoomAndUser(ChatRoom chatRoom, User user);

    Optional<ChatUser> findByChatRoomAndUser(ChatRoom chatRoom, User user);

    List<ChatUser> findByUser(User user);

}
