package com.semothon.spring_server.room.repository;

import com.semothon.spring_server.room.dto.RoomSearchCondition;
import com.semothon.spring_server.room.entity.Room;

import java.util.List;

public interface RoomRepositoryCustom {

    List<Room> searchRoomList(RoomSearchCondition condition, String currentUserId);
}
