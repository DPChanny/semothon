package com.semothon.spring_server.room.repository;

import com.semothon.spring_server.room.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long>, RoomRepositoryCustom {

    @Query("""
        SELECT r FROM Room r
        JOIN FETCH r.host
        LEFT JOIN FETCH r.chatRoom
        LEFT JOIN FETCH r.roomUsers ru
        LEFT JOIN FETCH ru.user
        WHERE r.roomId = :roomId
        """)
    Optional<Room> findByIdWithRoomUsersAndHost(Long roomId);
}
