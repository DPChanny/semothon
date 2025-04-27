package com.semothon.spring_server.chat.service;

import com.semothon.spring_server.chat.dto.ChatMessageRequestDto;
import com.semothon.spring_server.chat.dto.ChatMessageResponseDto;
import com.semothon.spring_server.chat.dto.UnreadMessageCountDto;
import com.semothon.spring_server.chat.entity.ChatMessage;
import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.entity.ChatUser;
import com.semothon.spring_server.chat.repository.ChatMessageRepository;
import com.semothon.spring_server.chat.repository.ChatRoomRepository;
import com.semothon.spring_server.chat.repository.ChatUserRepository;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
    public class ChatService {
    private final ChatUserRepository chatUserRepository;
    private final ChatRoomRepository chatRoomRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final UserRepository userRepository;
    private final SimpMessagingTemplate messagingTemplate; // 특정 사용자에게 메시지를 보내는데 사용되는 STOMP 를 이용한 템플릿



    public void handleChatMessage(ChatMessageRequestDto messageDto, String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));
        ChatRoom chatRoom = chatRoomRepository.findById(messageDto.getChatRoomId())
                .orElseThrow(() -> new InvalidInputException("chatRoom not found"));

        if (!isValidParticipant(chatRoom, user)) {
            log.warn("참여 권한 없음: userId={}, chatRoomId={}", userId, chatRoom.getChatRoomId());
            return;
        }

        // 저장
        ChatMessage chatMessage = ChatMessage.builder()
                .message(messageDto.getMessage())
                .imageUrl(messageDto.getImageUrl())
                .build();
        chatMessage.updateChatRoom(chatRoom);
        chatMessage.updateUser(user);
        chatMessageRepository.save(chatMessage);

        // 응답 브로드캐스트
        ChatMessageResponseDto response = ChatMessageResponseDto.from(chatMessage);
        messagingTemplate.convertAndSend("/sub/chat/" + chatRoom.getChatRoomId(), response);
    }

    private boolean isValidParticipant(ChatRoom chatRoom, User user) {
        return switch (chatRoom.getType()) {
            case ROOM, CRAWLING -> chatUserRepository.existsByChatRoomAndUser(chatRoom, user);
            case OPEN -> true;
            default -> false;
        };
    }

    @Transactional(readOnly = true)
    public List<UnreadMessageCountDto> getUnreadMessageSummary(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("User not found"));

        List<ChatUser> chatUsers = chatUserRepository.findByUser(user);

        return chatUsers.stream()
                .map(chatUser -> {
                    Long chatRoomId = chatUser.getChatRoom().getChatRoomId();
                    LocalDateTime lastReadAt = chatUser.getLastReadAt();
                    long count = chatMessageRepository.countUnreadMessages(chatRoomId, lastReadAt);
                    return new UnreadMessageCountDto(chatRoomId, count);
                })
                .toList();

    }
}
