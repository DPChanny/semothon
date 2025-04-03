package com.semothon.spring_server.crawling.repository;

import com.semothon.spring_server.crawling.entity.Crawling;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CrawlingRepository extends JpaRepository<Crawling, Long>, CrawlingRepositoryCustom {
}
