package com.semothon.spring_server.room.service;

import com.semothon.spring_server.chat.dto.UpdateChatRoomRequestDto;
import com.semothon.spring_server.chat.service.ChatRoomService;
import com.semothon.spring_server.common.exception.ForbiddenException;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.room.dto.*;
import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.room.entity.RoomUser;
import com.semothon.spring_server.room.entity.RoomUserRole;
import com.semothon.spring_server.room.repository.RoomInterestRepository;
import com.semothon.spring_server.room.repository.RoomRepository;
import com.semothon.spring_server.room.repository.RoomUserRepository;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.hibernate.Hibernate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class RoomService {
    private final RoomRepository roomRepository;
    private final RoomUserRepository roomUserRepository;
    private final UserRepository userRepository;
    private final ChatRoomService chatRoomService;
    private final RoomInterestRepository roomInterestRepository;

    @Transactional(readOnly = true)
    public GetRoomResponseDto getRoom(Long roomId) {
        Room room = roomRepository.findByIdWithRoomUsersAndHost(roomId)
                .orElseThrow(() -> new InvalidInputException("room not found"));

        return GetRoomResponseDto.from(room);
    }

    @Transactional(readOnly = true)
    public Room getRoomEntity(Long roomId) {
        return roomRepository.findById(roomId)
                .orElseThrow(() -> new InvalidInputException("room not found"));
    }

    public Long createRoom(String userId, CreateRoomRequestDto requestDto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));

        Room room = Room.builder()
                .title(requestDto.getTitle())
                .description(requestDto.getDescription())
                .capacity(requestDto.getCapacity())
                .build();
        room.updateHost(user);

        RoomUser roomUser = RoomUser.builder()
                .role(RoomUserRole.ADMIN)
                .build();
        roomUser.updateRoom(room);
        roomUser.updateUser(user);

        Room savedRoom = roomRepository.save(room);
        roomUserRepository.save(roomUser);

        chatRoomService.createRoomChat(savedRoom);

        return room.getRoomId();
    }

    public void deleteRoom(String userId, Long roomId) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new InvalidInputException("room not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));

        if(!room.getHost().getUserId().equals(user.getUserId())){
            throw new ForbiddenException("Only the host can delete the room.");
        }

        if (room.getChatRoom() != null) {
            chatRoomService.deleteChatRoom(room.getChatRoom().getChatRoomId(), user);
        }

        roomRepository.delete(room);
    }

    public GetRoomResponseDto joinRoom(String userId, Long roomId) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new InvalidInputException("room not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));

        if (roomUserRepository.existsByRoomAndUser(room, user)) {
            throw new InvalidInputException("User already joined the room");
        }

        if (room.getRoomUsers().size() >= room.getCapacity()) {
            throw new InvalidInputException("Room is full");
        }

        RoomUser roomUser = RoomUser.builder()
                .role(RoomUserRole.MEMBER)
                .build();
        roomUser.updateRoom(room);
        roomUser.updateUser(user);

        if (room.getChatRoom() != null) {
            chatRoomService.joinChatRoom(room.getChatRoom().getChatRoomId(), user);
        }
        roomUserRepository.save(roomUser);

        return GetRoomResponseDto.from(room);
    }

    public void leaveRoom(String userId, Long roomId) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new InvalidInputException("room not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));

        RoomUser roomUser = roomUserRepository.findByRoomAndUser(room, user)
                .orElseThrow(() -> new InvalidInputException("User not in the room."));

        if (roomUser.getRole() == RoomUserRole.ADMIN) {
            throw new ForbiddenException("Host cannot leave the room. Try deleting instead.");
        }

        if (room.getChatRoom() != null) {
            chatRoomService.leaveChatRoom(room.getChatRoom().getChatRoomId(), user);
        }

        roomUserRepository.delete(roomUser);
    }

    @Transactional(readOnly = true)
    public List<RoomWithScoreDto> getRoomList(String userId, RoomSearchCondition condition) {
        return roomRepository.searchRoomList(condition, userId);
    }

    public GetRoomResponseDto updateRoom(String userId, Long roomId, UpdateRoomRequestDto dto) {
        Room room = roomRepository.findByIdWithRoomUsersAndHost(roomId)
                .orElseThrow(() -> new InvalidInputException("room not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));

        if (!room.getHost().getUserId().equals(userId)) {
            throw new ForbiddenException("Only the host can edit the room.");
        }

        room.updateRoom(dto);
        // ChatRoom 동기화
        if (room.getChatRoom() != null) {
            chatRoomService.updateChatRoom(room.getChatRoom().getChatRoomId(), user,
                    UpdateChatRoomRequestDto.builder()
                            .title(dto.getTitle())
                            .description(dto.getDescription())
                            .capacity(dto.getCapacity())
                            .build());
        }

        return GetRoomResponseDto.from(room);
    }

    public void deleteRoomInterest(Room room) {
        Room managedRoom = roomRepository.findById(room.getRoomId())
                .orElseThrow(() -> new InvalidInputException("room not found"));
        roomInterestRepository.deleteAllByRoom(managedRoom);
    }
}
