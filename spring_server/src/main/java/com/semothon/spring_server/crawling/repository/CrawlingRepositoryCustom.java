package com.semothon.spring_server.crawling.repository;

import com.semothon.spring_server.crawling.dto.CrawlingSearchCondition;
import com.semothon.spring_server.crawling.entity.Crawling;

import java.util.List;

public interface CrawlingRepositoryCustom {
    List<Crawling> searchCrawlingList(CrawlingSearchCondition condition, String currentUserId);
}
