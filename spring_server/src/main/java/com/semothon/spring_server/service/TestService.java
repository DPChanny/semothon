package com.semothon.spring_server.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Value;

@Service
public class TestService {
    @Value("${external.fastapi.url}")
    private String fastapiUrl;

    public String getTestResult() {
        RestTemplate restTemplate = new RestTemplate();
        return restTemplate.getForObject(fastapiUrl + "/api/test", String.class);
    }
}