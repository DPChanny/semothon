package com.semothon.spring_server.room.repository;

import com.semothon.spring_server.room.entity.UserRoomRecommendation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRoomRecommendationRepository extends JpaRepository<UserRoomRecommendation, Long> {
}
