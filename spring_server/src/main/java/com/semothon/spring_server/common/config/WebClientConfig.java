package com.semothon.spring_server.common.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
public class WebClientConfig {

    @Bean
    public WebClient webClient(@Value("${external.fastapi.url}") String fastApiBaseUrl) {
        log.info("WebClient baseUrl = '{}'", fastApiBaseUrl);
        return WebClient.builder()
                .baseUrl(fastApiBaseUrl)
                .build();
    }
}
