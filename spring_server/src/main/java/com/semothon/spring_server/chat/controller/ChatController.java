package com.semothon.spring_server.chat.controller;

import com.semothon.spring_server.chat.dto.ChatMessageRequestDto;
import com.semothon.spring_server.chat.dto.ChatMessageResponseDto;
import com.semothon.spring_server.chat.dto.GetChatRoomResponseDto;
import com.semothon.spring_server.chat.service.ChatRoomService;
import com.semothon.spring_server.chat.service.ChatService;
import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.common.exception.ForbiddenException;
import com.semothon.spring_server.user.entity.User;
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
}
