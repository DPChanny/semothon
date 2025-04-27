package com.semothon.spring_server.room.repository;

import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.room.entity.RoomUser;
import com.semothon.spring_server.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoomUserRepository extends JpaRepository<RoomUser, Long> {
    boolean existsByRoomAndUser(Room room, User user);
    Optional<RoomUser> findByRoomAndUser(Room room, User user);
}
