package com.semothon.spring_server.ai.service;

import com.semothon.spring_server.ai.dto.FastApiIntroResponse;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.entity.UserInterest;
import com.semothon.spring_server.user.repository.UserInterestRepository;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.List;
import java.util.Map;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class AiService {
    private final WebClient webClient;

    @Value("${external.fastapi.url}")
    private String fastApiBaseUrl;

    @Transactional(readOnly = true)
    public String generateIntro(String userId) {
        String apiUrl = fastApiBaseUrl + "/api/ai/intro";

        try {
            FastApiIntroResponse response = webClient.post()
                    .uri(apiUrl)
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
        String apiUrl = fastApiBaseUrl + "/api/ai/interest/user";

        try {
            FastApiIntroResponse response = webClient.post()
                    .uri(apiUrl)
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
        String apiUrl = fastApiBaseUrl + "/api/ai/recommend/room/by-user";

        try {
            FastApiIntroResponse response = webClient.post()
                    .uri(apiUrl)
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
        String apiUrl = fastApiBaseUrl + "/api/ai/recommend/crawling/by-user";

        try {
            FastApiIntroResponse response = webClient.post()
                    .uri(apiUrl)
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
        String apiUrl = fastApiBaseUrl + "/api/ai/interest/room";

        try {
            FastApiIntroResponse response = webClient.post()
                    .uri(apiUrl)
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
        String apiUrl = fastApiBaseUrl + "/api/ai/recommend/room/by-room";

        try {
            FastApiIntroResponse response = webClient.post()
                    .uri(apiUrl)
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
