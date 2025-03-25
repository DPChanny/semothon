package com.semothon.spring_server.controller;

import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.service.TestService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class TestController {

    private final TestService testService;

    @GetMapping("/test")
    public ResponseEntity<String> test() {
        String result = testService.getTestResult();
        return ResponseEntity.ok(result);
    }

    @GetMapping("/public/test")
    @ResponseStatus(HttpStatus.OK)
    public String test2(){
        return "ok";
    }

    @GetMapping("/private/test")
    @ResponseStatus(HttpStatus.OK)
    public String test3(){
        return "ok";
    }
}