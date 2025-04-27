package com.semothon.spring_server.recommend.controller;

import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.recommend.dto.RecommendRoomResponseDto;
import com.semothon.spring_server.user.dto.GetUserResponseDto;
import com.semothon.spring_server.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/recommend")
public class RecommendController {

    // @GetMapping("/group")
    // @ResponseStatus(HttpStatus.OK)
    // public RecommendRoomResponseDto recommendGroup(
    //         @AuthenticationPrincipal User user
    // ){
    //     return RecommendRoomResponseDto.from()
    // }
}
