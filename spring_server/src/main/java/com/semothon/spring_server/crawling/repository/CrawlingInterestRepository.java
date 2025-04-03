package com.semothon.spring_server.crawling.repository;

import com.semothon.spring_server.crawling.entity.CrawlingInterest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CrawlingInterestRepository extends JpaRepository<CrawlingInterest, Long> {
}
