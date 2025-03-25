package com.semothon.spring_server.user.controller;

import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.user.dto.GetUserResponseDto;
import com.semothon.spring_server.user.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/users")
public class UserController {

    @PostMapping("/login")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse userLogin(
            @AuthenticationPrincipal User user
    ){
        return BaseResponse.success(Map.of("code", 200, "user", GetUserResponseDto.from(user)), "Login successful");
    }

}
