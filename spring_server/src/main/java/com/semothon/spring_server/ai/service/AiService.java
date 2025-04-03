package com.semothon.spring_server.ai.service;

import com.semothon.spring_server.ai.dto.FastApiIntroResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.HttpHeaders;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.Map;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class AiService {
    private final WebClient webClient;

    @Transactional(readOnly = true)
    public String generateIntro(String userId) {
        try {
            FastApiIntroResponse response = webClient.post()
                    .uri("/api/ai/intro")
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                    .bodyValue(Map.of("user_id", userId))
                    .retrieve()
                    .bodyToMono(FastApiIntroResponse.class)
                    .block();

            if (response != null && response.isSuccess()) {
                return response.getIntro();
            } else {
                throw new RuntimeException("FastAPI intro generation failed: " + (response != null ? response.getMessage() : "unknown error"));
            }
        } catch (Exception e) {
            throw new RuntimeException("FastAPI intro request failed", e);
        }
    }

    @Transactional
    public String updateInterestByIntroText(String userId) {
        try {
            FastApiIntroResponse response = webClient.post()
                    .uri("/api/ai/interest/user")
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                    .bodyValue(Map.of("user_id", userId))
                    .retrieve()
                    .bodyToMono(FastApiIntroResponse.class)
                    .block();

            if (response != null && response.isSuccess()) {
                return response.getMessage();
            } else {
                throw new RuntimeException("FastAPI update interests failed: " + (response != null ? response.getMessage() : "unknown error"));
            }
        } catch (Exception e) {
            throw new RuntimeException("FastAPI interest/user request failed", e);
        }
    }

    @Transactional
    public String updateUserRoomRecommendation(String userId) {
        try {
            FastApiIntroResponse response = webClient.post()
                    .uri("/api/ai/recommend/room/by-user")
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                    .bodyValue(Map.of("user_id", userId))
                    .retrieve()
                    .bodyToMono(FastApiIntroResponse.class)
                    .block();

            if (response != null && response.isSuccess()) {
                return response.getMessage();
            } else {
                throw new RuntimeException("FastAPI update UserRoomRecommendation failed: " + (response != null ? response.getMessage() : "unknown error"));
            }
        } catch (Exception e) {
            throw new RuntimeException("FastAPI interest/user request failed", e);
        }
    }

    @Transactional
    public String updateUserCrawlingRecommendation(String userId) {
        try {
            FastApiIntroResponse response = webClient.post()
                    .uri("/api/ai/recommend/crawling/by-user")
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                    .bodyValue(Map.of("user_id", userId))
                    .retrieve()
                    .bodyToMono(FastApiIntroResponse.class)
                    .block();

            if (response != null && response.isSuccess()) {
                return response.getMessage();
            } else {
                throw new RuntimeException("FastAPI update UserCrawlingRecommendation failed: " + (response != null ? response.getMessage() : "unknown error"));
            }
        } catch (Exception e) {
            throw new RuntimeException("FastAPI interest/user request failed", e);
        }
    }

    @Transactional
    public String updateInterestByRoomDescription(Long roomId) {
        try {
            FastApiIntroResponse response = webClient.post()
                    .uri("/api/ai/interest/room")
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                    .bodyValue(Map.of("room_id", String.valueOf(roomId)))
                    .retrieve()
                    .bodyToMono(FastApiIntroResponse.class)
                    .block();

            if (response != null && response.isSuccess()) {
                return response.getMessage();
            } else {
                throw new RuntimeException("FastAPI update interests from room failed: " +
                        (response != null ? response.getMessage() : "unknown error"));
            }
        } catch (Exception e) {
            throw new RuntimeException("FastAPI interest/room request failed", e);
        }
    }

    @Transactional
    public String updateAllUserRoomRecommendationByRoom(Long roomId) {
        try {
            FastApiIntroResponse response = webClient.post()
                    .uri("/api/ai/recommend/room/by-room")
                    .header(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
                    .bodyValue(Map.of("room_id", String.valueOf(roomId)))
                    .retrieve()
                    .bodyToMono(FastApiIntroResponse.class)
                    .block();

            if (response != null && response.isSuccess()) {
                return response.getMessage();
            } else {
                throw new RuntimeException("FastAPI update recommendation by room failed: " +
                        (response != null ? response.getMessage() : "unknown error"));
            }
        } catch (Exception e) {
            throw new RuntimeException("FastAPI recommend/room/by-room request failed", e);
        }
    }
}
