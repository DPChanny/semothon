package com.semothon.spring_server.common.config.Interceptor;

import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.repository.ChatRoomRepository;
import com.semothon.spring_server.chat.repository.ChatUserRepository;
import com.semothon.spring_server.common.exception.ForbiddenException;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.stereotype.Component;

import java.util.Map;

/**
 * SUBSCRIBE, SEND 등의 요청을 가로채 권한 검증 등의 역할을 수행
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ChatChannelInterceptor implements ChannelInterceptor {
    private final UserRepository userRepository;
    private final ChatRoomRepository chatRoomRepository;
    private final ChatUserRepository chatUserRepository;

    @Override
    public Message<?> preSend(Message<?> message, MessageChannel channel) {

        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);

        if (accessor == null) return message;

        // 구독 요청만 필터링
        if (StompCommand.SUBSCRIBE.equals(accessor.getCommand())) {
            String destination = accessor.getDestination(); // 구독할 목적지 ex) /sub/chat/1
            String userId = (String) accessor.getSessionAttributes().get("userId");

            if (userId == null || destination == null) {
                throw new ForbiddenException("Unauthorized subscription request");
            }

            // 채팅방 ID 추출
            Long chatRoomId = parseChatRoomId(destination);
            if (chatRoomId == null) {
                throw new IllegalArgumentException("Invalid subscription destination: " + destination);
            }

            // 유저 & 채팅방 유효성 검사
            User user = userRepository.findById(userId)
                    .orElseThrow(() -> new InvalidInputException("User not found"));

            ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                    .orElseThrow(() -> new InvalidInputException("ChatRoom not found"));

            if (!isValidParticipant(chatRoom, user)) {
                log.warn("SUBSCRIBE DENIED: userId={}, chatRoomId={}", userId, chatRoomId);
                throw new ForbiddenException("User is not a participant of this chat room");
            }

            log.info("SUBSCRIBE ALLOWED: userId={}, chatRoomId={}", userId, chatRoomId);
        }

        return message;
    }

    private Long parseChatRoomId(String destination) {
        try {
            if (destination.startsWith("/sub/chat/")) {
                return Long.parseLong(destination.substring("/sub/chat/".length()));
            }
        } catch (Exception e) {
            log.error("채팅방 ID 파싱 실패: {}", destination);
        }
        return null;
    }

    private boolean isValidParticipant(ChatRoom chatRoom, User user) {
        return switch (chatRoom.getType()) {
            case ROOM, CRAWLING -> chatUserRepository.existsByChatRoomAndUser(chatRoom, user);
            case OPEN -> true;
            default -> false;
        };
    }

}
