package com.semothon.spring_server.common.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.reactive.function.client.WebClient;

@Configuration
public class WebClientConfig {
    
    @Value("${external.fastapi.url}")
    private String fastApiBaseUrl;

    @Bean
    public WebClient webClient() {
        return WebClient.builder().baseUrl(fastApiBaseUrl).build();
    }
}
