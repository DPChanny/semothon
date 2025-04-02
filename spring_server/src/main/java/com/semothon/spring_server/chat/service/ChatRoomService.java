package com.semothon.spring_server.chat.service;

import com.semothon.spring_server.chat.dto.GetChatRoomResponseDto;
import com.semothon.spring_server.chat.dto.UpdateChatRoomRequestDto;
import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.entity.ChatRoomType;
import com.semothon.spring_server.chat.entity.ChatUser;
import com.semothon.spring_server.chat.entity.ChatUserRole;
import com.semothon.spring_server.chat.repository.ChatRoomRepository;
import com.semothon.spring_server.chat.repository.ChatUserRepository;
import com.semothon.spring_server.common.exception.ForbiddenException;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.crawling.entity.Crawling;
import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.user.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


/**
 * 채팅방 생성, 수정, 삭제, 참여, 탈퇴에 관한 서비스 클래스
 * 이 클래스는 RoomController, CrawlingController 에서 호출되어 채팅방을 관리하도록 동작할 것
 */

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class ChatRoomService {
    private final ChatRoomRepository chatRoomRepository;
    private final ChatUserRepository chatUserRepository;

    // room 기반 chatRoom 생성
    public GetChatRoomResponseDto createRoomChat(Room room){
        if (room.getChatRoom() != null) {
            throw new InvalidInputException("room already has chatting room");
        }

        ChatRoom chatRoom = ChatRoom.builder()
                .type(ChatRoomType.ROOM)
                .title(room.getTitle())
                .description(room.getDescription())
                .capacity(room.getCapacity())
                .build();
        chatRoom.updateHost(room.getHost());
        chatRoom.updateRoom(room);

        ChatUser chatUser = ChatUser.builder()
                .role(ChatUserRole.ADMIN)
                .build();
        chatUser.updateUser(room.getHost());
        chatUser.updateChatRoom(chatRoom);

        ChatRoom savedChatRoom = chatRoomRepository.save(chatRoom);
        chatUserRepository.save(chatUser);

        return GetChatRoomResponseDto.from(savedChatRoom);
    }

    // crawling 기반 chatRoom 생성
    public GetChatRoomResponseDto createCrawlingChat(Crawling crawling, User host, String title, String description, Integer capacity){
        ChatRoom chatRoom = ChatRoom.builder()
                .type(ChatRoomType.CRAWLING)
                .title(title)
                .description(description)
                .capacity(capacity)
                .build();
        chatRoom.updateCrawling(crawling);
        chatRoom.updateHost(host);

        ChatUser chatUser = ChatUser.builder()
                .role(ChatUserRole.ADMIN)
                .build();
        chatUser.updateChatRoom(chatRoom);
        chatUser.updateUser(host);

        ChatRoom savedChatRoom = chatRoomRepository.save(chatRoom);
        chatUserRepository.save(chatUser);

        return GetChatRoomResponseDto.from(savedChatRoom);
    }

    // chatRoom 수정
    public GetChatRoomResponseDto updateChatRoom(Long chatRoomId, User requester, UpdateChatRoomRequestDto dto){
        ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                .orElseThrow(() -> new InvalidInputException("chatRoom not found"));

        if (!chatRoom.getHost().getUserId().equals(requester.getUserId())) {
            throw new ForbiddenException("only host can edit chatting room");
        }
        chatRoom.updateChatRoom(dto);
        return GetChatRoomResponseDto.from(chatRoom);
    }

    // chatRoom 조회
    @Transactional(readOnly = true)
    public GetChatRoomResponseDto getChatRoom(Long chatRoomId){
        ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                .orElseThrow(() -> new InvalidInputException("chatRoom not found"));
        return GetChatRoomResponseDto.from(chatRoom);
    }

    //chatRoom 삭제
    public void deleteChatRoom(Long chatRoomId, User requester){
        ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                .orElseThrow(() -> new InvalidInputException("chatRoom not found"));

        if (!chatRoom.getHost().getUserId().equals(requester.getUserId())) {
            throw new ForbiddenException("only host can delete chatting room");
        }

        chatRoomRepository.delete(chatRoom);
    }

    // chatRoom 참여
    public GetChatRoomResponseDto joinChatRoom(Long chatRoomId, User user){
        ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                .orElseThrow(() -> new InvalidInputException("chatRoom not found"));

        boolean alreadyJoined = chatUserRepository.existsByChatRoomAndUser(chatRoom, user);

        if(alreadyJoined){
            throw new InvalidInputException("user already joined chatting room");
        }else{
            if (chatRoom.getChatUsers().size() >= chatRoom.getCapacity()) {
                throw new InvalidInputException("chatting room is full");
            }

            ChatUser chatUser = ChatUser.builder()
                    .chatRoom(chatRoom)
                    .role(ChatUserRole.MEMBER)
                    .build();
            chatUser.updateChatRoom(chatRoom);
            chatUser.updateUser(user);
            chatUserRepository.save(chatUser);
        }
        return GetChatRoomResponseDto.from(chatRoom);
    }


    //chatRoom 탈퇴
    public GetChatRoomResponseDto leaveChatRoom(Long chatRoomId, User user){
        ChatRoom chatRoom = chatRoomRepository.findById(chatRoomId)
                .orElseThrow(() -> new InvalidInputException("chatRoom not found"));

        ChatUser chatUser = chatUserRepository.findByChatRoomAndUser(chatRoom, user)
                .orElseThrow(() -> new InvalidInputException("this user are not joined this chatting room"));

        chatUserRepository.delete(chatUser);

        return GetChatRoomResponseDto.from(chatRoom);
    }
}
