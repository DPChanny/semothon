package com.semothon.spring_server.crawling.repository;

import com.semothon.spring_server.crawling.entity.UserCrawlingRecommendation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserCrawlingRecommendationRepository extends JpaRepository<UserCrawlingRecommendation, Long> {
}
