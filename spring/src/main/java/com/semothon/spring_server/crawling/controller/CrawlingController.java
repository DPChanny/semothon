package com.semothon.spring_server.crawling.controller;

import com.semothon.spring_server.chat.dto.ChatRoomInfoDto;
import com.semothon.spring_server.chat.dto.CreateChatRoomRequestDto;
import com.semothon.spring_server.chat.dto.GetChatRoomResponseDto;
import com.semothon.spring_server.chat.dto.UpdateChatRoomRequestDto;
import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.crawling.dto.*;
import com.semothon.spring_server.crawling.entity.Crawling;
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
import java.util.stream.Collectors;

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
    public BaseResponse getCrawlingList(
            @AuthenticationPrincipal User user,
            @ModelAttribute @Valid CrawlingSearchCondition condition
    ) {
        //default value 명시적 설정
        if (condition.getSortBy() == null) {
            condition.setSortBy(CrawlingSortBy.CRAWLED_AT);
        }
        if (condition.getSortDirection() == null) {
            condition.setSortDirection(CrawlingSortDirection.DESC);
        }
        if (condition.getPage() == null) {
            condition.setPage(0);
        }
        if (condition.getLimit() == null) {
            condition.setLimit(10);
        }

        if(condition.getCrawledAfter() != null){
            condition.setCrawledAfter(DateTimeUtil.convertKSTToUTC(condition.getCrawledAfter()));
        }
        if(condition.getCrawledBefore() != null){
            condition.setCrawledBefore(DateTimeUtil.convertKSTToUTC(condition.getCrawledBefore()));
        }
        if(condition.getDeadlinedAfter() != null){
            condition.setDeadlinedAfter(DateTimeUtil.convertKSTToUTC(condition.getDeadlinedAfter()));
        }
        if(condition.getDeadlinedBefore() != null){
            condition.setDeadlinedBefore(DateTimeUtil.convertKSTToUTC(condition.getDeadlinedBefore()));
        }

        List<CrawlingWithScoreDto> crawlingList = crawlingService.getCrawlingList(user.getUserId(), condition);
        List<GetCrawlingListResponseDto> result = crawlingList.stream()
                .map(c -> GetCrawlingListResponseDto.from(c.crawling(), c.score()))
                .toList();

        return BaseResponse.success(Map.of("code", 200, "totalCount", result.size(),"crawlingList", result), "Crawling list retrieved successfully");
    }

    @PostMapping("/{crawlingId}/chats")
    @ResponseStatus(HttpStatus.CREATED)
    public BaseResponse createChatRoom(@AuthenticationPrincipal User user,
                                       @PathVariable Long crawlingId,
                                       @RequestBody @Valid CreateChatRoomRequestDto dto) {
        GetChatRoomResponseDto chatRoomResponseDto = crawlingService.createChatRoom(user.getUserId(), crawlingId, dto);
        return BaseResponse.success(Map.of("code", 201, "chatRoom", chatRoomResponseDto), "Chat room created successfully");
    }

    @PatchMapping("/{crawlingId}/chats/{chatRoomId}")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse updateChatRoom(@AuthenticationPrincipal User user,
                                       @PathVariable Long crawlingId,
                                       @PathVariable Long chatRoomId,
                                       @RequestBody UpdateChatRoomRequestDto dto) {
        GetChatRoomResponseDto getChatRoomResponseDto = crawlingService.updateChatRoom(user.getUserId(), crawlingId, chatRoomId, dto);
        return BaseResponse.success(Map.of("code", 200, "chatRoom", getChatRoomResponseDto), "Chat room updated successfully");
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
        GetChatRoomResponseDto getChatRoomResponseDto = crawlingService.joinChatRoom(user.getUserId(), crawlingId, chatRoomId);
        return BaseResponse.success(Map.of("code", 200, "chatRoom", getChatRoomResponseDto), "Joined chat room successfully");
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
