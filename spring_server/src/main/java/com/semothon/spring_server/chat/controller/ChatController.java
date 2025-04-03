package com.semothon.spring_server.chat.controller;

import com.semothon.spring_server.chat.dto.ChatMessageRequestDto;
import com.semothon.spring_server.chat.service.ChatService;
import com.semothon.spring_server.common.exception.ForbiddenException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;

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
}
