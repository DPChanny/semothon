package com.semothon.spring_server.chat.controller;

import com.semothon.spring_server.chat.dto.*;
import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.service.ChatRoomService;
import com.semothon.spring_server.chat.service.ChatService;
import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.common.exception.ForbiddenException;
import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.user.entity.User;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final ChatRoomService chatRoomService;

    // 클라이언트가 /pub/chat/message 로 보낸 메시지 처리
    @MessageMapping("/chat/message")
    public void handleMessage(@Payload ChatMessageRequestDto message,
                            SimpMessageHeaderAccessor headerAccessor) {

        String userId = (String) headerAccessor.getSessionAttributes().get("userId");
        if (userId == null) {
            throw new ForbiddenException("User is not authenticated.");
        }
        log.info("메시지 수신: userId={}, chatRoomId={}, message={}", userId, message.getChatRoomId(), message.getMessage());

        chatService.handleChatMessage(message, userId);
    }

    @GetMapping("/api/chats/{chatRoomId}")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getChatRoomInfo(
            @PathVariable Long chatRoomId
    ){
        GetChatRoomResponseDto chatRoomResponseDto = chatRoomService.getChatRoom(chatRoomId);
        return BaseResponse.success(Map.of("code", 200, "chatRoom", chatRoomResponseDto), "ChatRoom retrieved successfully");
    }

    @GetMapping("/api/chats/{chatRoomId}/messages")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getMessages(
            @AuthenticationPrincipal User user,
            @PathVariable Long chatRoomId
    ){
        String currentUserId = user.getUserId();
        List<ChatMessageResponseDto> messages = chatRoomService.getMessages(chatRoomId, currentUserId);
        return BaseResponse.success(Map.of("code", 200, "chatMessages", messages), "ChatMessages retrieved successfully");
    }


    @GetMapping("/api/chats")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getChatRoomList(
            @AuthenticationPrincipal User user,
            @ModelAttribute @Valid ChatRoomSearchCondition condition
    ) {
        // 기본값 설정
        if (condition.getSortBy() == null) {
            condition.setSortBy(ChatRoomSortBy.CREATED_AT);
        }
        if (condition.getSortDirection() == null) {
            condition.setSortDirection(ChatRoomSortDirection.DESC);
        }
        if (condition.getPage() == null) {
            condition.setPage(0);
        }
        if (condition.getLimit() == null) {
            condition.setLimit(10);
        }
        if (condition.getJoinedOnly() == null) {
            condition.setJoinedOnly(false);
        }
        if (condition.getExcludeJoined() == null) {
            condition.setExcludeJoined(false);
        }

        // 날짜 UTC 변환
        if (condition.getCreatedAfter() != null) {
            condition.setCreatedAfter(DateTimeUtil.convertKSTToUTC(condition.getCreatedAfter()));
        }
        if (condition.getCreatedBefore() != null) {
            condition.setCreatedBefore(DateTimeUtil.convertKSTToUTC(condition.getCreatedBefore()));
        }

        // 서비스 호출
        List<ChatRoom> chatRoomList = chatRoomService.getChatRoomList(user.getUserId(), condition);

        List<ChatRoomInfoDto> responseDtos = chatRoomList.stream()
                .map(ChatRoomInfoDto::from)
                .toList();

        return BaseResponse.success(
                Map.of("code", 200, "totalCount", responseDtos.size(), "chatRoomList", responseDtos),
                "Chat room search results retrieved successfully"
        );
    }

    @GetMapping("/api/chats/unread-count")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getUnreadMessageCount(
            @AuthenticationPrincipal User user
    ){
        List<UnreadMessageCountDto> unreadCounts = chatService.getUnreadMessageSummary(user.getUserId());
        return BaseResponse.success(
                Map.of("code", 200, "unreadCounts", unreadCounts),
                "Unread message summary retrieved"
        );
    }
}
