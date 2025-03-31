package com.semothon.spring_server.ai.service;

import com.semothon.spring_server.ai.dto.FastApiIntroResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.reactive.function.client.WebClient;

import java.util.Map;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class AiService {
    private final WebClient webClient;

    @Value("${external.fastapi.url}")
    private String fastApiBaseUrl;

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    public String generateIntroAfterCommit(String userId) {
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
