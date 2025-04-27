package com.semothon.spring_server.room.repository;

import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.room.entity.RoomInterest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RoomInterestRepository extends JpaRepository<RoomInterest, Long> {
    void deleteAllByRoom(Room room);
}
