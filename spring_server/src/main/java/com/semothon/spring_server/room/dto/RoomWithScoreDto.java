package com.semothon.spring_server.room.dto;

import com.semothon.spring_server.room.entity.Room;

public record RoomWithScoreDto(Room room, Double score) {
}
