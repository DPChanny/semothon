package com.semothon.spring_server.crawling.dto;

import com.semothon.spring_server.crawling.entity.Crawling;

public record CrawlingWithScoreDto(Crawling crawling, Double score) {
}
