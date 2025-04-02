package com.semothon.spring_server.common.config.handler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.semothon.spring_server.chat.dto.ChatMessageRequestDto;
import com.semothon.spring_server.chat.dto.ChatMessageResponseDto;
import com.semothon.spring_server.chat.entity.ChatMessage;
import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.repository.ChatMessageRepository;
import com.semothon.spring_server.chat.repository.ChatRoomRepository;
import com.semothon.spring_server.chat.repository.ChatUserRepository;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import java.net.URI;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 채팅 Websocket 연결을 관리할 핸들러
 * 텍스트 기반의  WebSocket 메시지 처리
 * 연결 설정 이후 처리, 텍스트 데이터 처리, 연결 종류 이후 처리 등의 작업을 정의
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ChatWebSocketHandler extends TextWebSocketHandler {

    // chatRoom Id를 key 로 설정하고, 해당 chatRoom 에 연결되어 있는 session 들을 저장 => 추후 받은 데이터를 broadcast 하는 등의 작업을 진행할 때 사용
    private final Map<Long, Set<WebSocketSession>> chatRoomSessions = new ConcurrentHashMap<>();

    private final ObjectMapper objectMapper = new ObjectMapper();

    private final ChatUserRepository chatUserRepository;
    private final ChatRoomRepository chatRoomRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;


    //  WebSocket 협상이 성공적으로 완료되고 WebSocket 연결이 열려 사용할 준비가 된 후 호출
    // chatRoom 과 user의 정보를 기반으로 참여할 수 있는 지를 판단 후 가능하면 session 을 chatRoomSessions 에 추가
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        Long chatRoomId = extractChatRoomId(session);
        String userId = extractUserId(session);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));
        ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                .orElseThrow(() -> new InvalidInputException("chatRoom not found"));

        log.info("WebSocket 연결시도: userId={}, chatRoomId={}", userId, chatRoomId);


        // 유효성 검증: chat_users 테이블에서 참여 여부 확인
        if (!isValidParticipant(chatRoom, user)) {
            log.warn("참여 권한 없음: userId={}, chatRoomId={}", userId, chatRoomId);
            session.close(CloseStatus.NOT_ACCEPTABLE);
            return;
        }

        chatRoomSessions.computeIfAbsent(chatRoomId, k -> new HashSet<>()).add(session);

        log.info("WebSocket 연결 완료: userId={}, chatRoomId={}", userId, chatRoomId);
    }


    // 새로운 WebSocket 메시지가 도착했을 때 호출
    // 전달 받은 메시지를 순회하면서 메시지를 전송
    @Override
    protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        ChatMessageRequestDto messageDto = objectMapper.readValue(message.getPayload(), ChatMessageRequestDto.class);
        String userId = extractUserId(session);
        Long chatRoomId = messageDto.getChatRoomId();

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));
        ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                .orElseThrow(() -> new InvalidInputException("chatRoom not found"));

        log.info("메시지 수신: chatRoomId={}, userId={}, message={}", chatRoomId, userId, messageDto.getMessage());

        // 유효성 재검증
        if (!isValidParticipant(chatRoom, user)) {
            log.warn("메시지 권한 없음: userId={}, chatRoomId={}", userId, chatRoomId);
            session.close(CloseStatus.NOT_ACCEPTABLE);
            return;
        }

        // DB 저장
        ChatMessage chatMessage = ChatMessage.builder()
                .chatRoom(chatRoom)
                .user(user)
                .message(messageDto.getMessage())
                .imageUrl(messageDto.getImageUrl())
                .build();
        chatMessageRepository.save(chatMessage);

        // 브로드캐스트
        String payload = objectMapper.writeValueAsString(ChatMessageResponseDto.from(chatMessage));
        for (WebSocketSession s : chatRoomSessions.getOrDefault(chatRoomId, Set.of())) {
            if (s.isOpen()) {
                s.sendMessage(new TextMessage(payload));
            }
        }
    }
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        Long chatRoomId = extractChatRoomId(session);
        chatRoomSessions.getOrDefault(chatRoomId, Set.of()).remove(session);
        log.info("연결 종료: chatRoomId={}, sessionId={}", chatRoomId, session.getId());
    }

    //URI 에서 쿼리 파라미터의 roomId를 파싱해 roomId를 획득
    private Long extractChatRoomId(WebSocketSession session) {
        URI uri = session.getUri();
        if (uri == null || uri.getQuery() == null) return null;

        String query = uri.getQuery();
        return Arrays.stream(query.split("&"))
                .filter(param -> param.startsWith("chatRoomId="))
                .map(param -> param.substring("chatRoomId=".length()))
                .map(Long::parseLong)
                .findFirst()
                .orElse(null);
    }

    // AuthHandshakeInterceptor 에서 검증 후 저장한 userId를 획득
    private String extractUserId(WebSocketSession session) {
        return (String) session.getAttributes().get("userId");
    }

    // user 가 해당 chat 에 참여할 수 있는 지 여부를 검증
    private boolean isValidParticipant(ChatRoom chatRoom, User user) {
        switch (chatRoom.getType()) {
            case ROOM, CRAWLING -> {
                return chatUserRepository.existsByChatRoomAndUser(chatRoom, user);
            }
            case OPEN -> {
                return true;
            }
            default -> {
                return false;
            }
        }
    }
}