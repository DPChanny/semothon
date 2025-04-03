package com.semothon.spring_server.crawling.controller;

import com.semothon.spring_server.chat.dto.CreateChatRoomRequestDto;
import com.semothon.spring_server.chat.dto.UpdateChatRoomRequestDto;
import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.crawling.dto.GetCrawlingResponseDto;
import com.semothon.spring_server.crawling.service.CrawlingService;
import com.semothon.spring_server.user.entity.User;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/crawlings")
public class CrawlingController {

    private final CrawlingService crawlingService;


    @GetMapping("/{crawlingId}")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getCrawling(@PathVariable Long crawlingId) {
        GetCrawlingResponseDto dto = crawlingService.getCrawling(crawlingId);
        return BaseResponse.success(Map.of("code", 200, "crawling", dto), "Crawling retrieved successfully");
    }

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getCrawlingList(@RequestParam(required = false) String keyword) {
        //마지막에 구현
        List<GetCrawlingResponseDto> result = crawlingService.getCrawlingList(keyword);
        return BaseResponse.success(Map.of("code", 200, "totalCount", 0,"crawlings", result), "Crawling list retrieved successfully");
    }

    @PostMapping("/{crawlingId}/chats")
    @ResponseStatus(HttpStatus.CREATED)
    public BaseResponse createChatRoom(@AuthenticationPrincipal User user,
                                       @PathVariable Long crawlingId,
                                       @RequestBody @Valid CreateChatRoomRequestDto dto) {
        Long chatRoomId = crawlingService.createChatRoom(user.getUserId(), crawlingId, dto);
        return BaseResponse.success(Map.of("code", 201, "chatRoomId", chatRoomId), "Chat room created successfully");
    }

    @PatchMapping("/{crawlingId}/chats/{chatRoomId}")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse updateChatRoom(@AuthenticationPrincipal User user,
                                       @PathVariable Long crawlingId,
                                       @PathVariable Long chatRoomId,
                                       @RequestBody UpdateChatRoomRequestDto dto) {
        crawlingService.updateChatRoom(user.getUserId(), crawlingId, chatRoomId, dto);
        return BaseResponse.success(Map.of("code", 200), "Chat room updated successfully");
    }

    @DeleteMapping("/{crawlingId}/chats/{chatRoomId}")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse deleteChatRoom(@AuthenticationPrincipal User user,
                                       @PathVariable Long crawlingId,
                                       @PathVariable Long chatRoomId) {
        crawlingService.deleteChatRoom(user.getUserId(), crawlingId, chatRoomId);
        return BaseResponse.success(Map.of("code", 200), "Chat room deleted successfully");
    }

    @PostMapping("/{crawlingId}/chats/{chatRoomId}/join")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse joinChatRoom(@AuthenticationPrincipal User user,
                                     @PathVariable Long crawlingId,
                                     @PathVariable Long chatRoomId) {
        crawlingService.joinChatRoom(user.getUserId(), crawlingId, chatRoomId);
        return BaseResponse.success(Map.of("code", 200), "Joined chat room successfully");
    }

    @PostMapping("/{crawlingId}/chats/{chatRoomId}/leave")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse leaveChatRoom(@AuthenticationPrincipal User user,
                                      @PathVariable Long crawlingId,
                                      @PathVariable Long chatRoomId) {
        crawlingService.leaveChatRoom(user.getUserId(), crawlingId, chatRoomId);
        return BaseResponse.success(Map.of("code", 200), "Left chat room successfully");
    }
}
