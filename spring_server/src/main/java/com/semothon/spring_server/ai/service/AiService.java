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
    private final UserRepository userRepository;
    private final UserInterestRepository userInterestRepository;

    @Value("${external.fastapi.url}")
    private String fastApiBaseUrl;

    @Transactional(readOnly = true)
    public String generateIntroAfterCommit(String userId) {

        // [1] DB에서 유저 조회
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found with id: " + userId));

        // [2] 관심사 - 리포지토리를 통해 DB에서 직접 조회 (영속성 컨텍스트 영향 X)
        List<UserInterest> persistedUserInterests = userInterestRepository.findAllByUser(user);

        log.info("[FastAPI Intro 생성] userId: {}, DB에서 조회한 관심사 수: {}, 관심사: {}",
                userId,
                persistedUserInterests.size(),
                persistedUserInterests.stream()
                        .map(userInterest -> userInterest.getInterest().getName())
                        .toList()
        );

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
}
