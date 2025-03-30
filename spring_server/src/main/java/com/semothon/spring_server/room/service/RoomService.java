package com.semothon.spring_server.room.service;

import com.semothon.spring_server.chat.entity.ChatRoom;
import com.semothon.spring_server.chat.entity.ChatRoomType;
import com.semothon.spring_server.chat.repository.ChatRoomRepository;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.common.exception.ForbiddenException;
import com.semothon.spring_server.room.dto.CreateRoomRequestDto;
import com.semothon.spring_server.room.dto.GetRoomResponseDto;
import com.semothon.spring_server.room.dto.RoomSearchCondition;
import com.semothon.spring_server.room.dto.RoomUserInfoDto;
import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.room.entity.RoomUser;
import com.semothon.spring_server.room.entity.RoomUserRole;
import com.semothon.spring_server.room.repository.RoomRepository;
import com.semothon.spring_server.room.repository.RoomUserRepository;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
    private final ChatRoomRepository chatRoomRepository;
    private final UserRepository userRepository;

    @Transactional(readOnly = true)
    public GetRoomResponseDto getRoom(Long roomId) {
        Room room = roomRepository.findByIdWithRoomUsersAndHost(roomId)
                .orElseThrow(() -> new InvalidInputException("room not found"));

        return GetRoomResponseDto.from(room);
    }

    public GetRoomResponseDto createRoom(String userId, CreateRoomRequestDto requestDto) {
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

        ChatRoom chatRoom = ChatRoom.builder()
                .type(ChatRoomType.GROUP)
                .build();
        chatRoom.updateRoom(room);

        roomRepository.save(room);
        chatRoomRepository.save(chatRoom);
        roomUserRepository.save(roomUser);

        return GetRoomResponseDto.from(room);
    }

    public void deleteRoom(String userId, Long roomId) {
        Room room = roomRepository.findById(roomId)
                .orElseThrow(() -> new InvalidInputException("room not found"));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));

        if(!room.getHost().getUserId().equals(user.getUserId())){
            throw new ForbiddenException("Only the host can delete the room.");
        }

        roomRepository.delete(room);
    }

    public RoomUserInfoDto joinRoom(String userId, Long roomId) {
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

        roomUserRepository.save(roomUser);

        return RoomUserInfoDto.from(roomUser);
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

        roomUserRepository.delete(roomUser);
    }

    public List<Room> getRoomList(String userId, RoomSearchCondition condition) {
        return roomRepository.searchRoomList(condition, userId);
    }
}
