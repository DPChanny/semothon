package com.semothon.spring_server.room.controller;

import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.room.dto.CreateRoomRequestDto;
import com.semothon.spring_server.room.dto.GetRoomResponseDto;
import com.semothon.spring_server.room.dto.RoomUserInfoDto;
import com.semothon.spring_server.room.service.RoomService;
import com.semothon.spring_server.user.dto.GetUserResponseDto;
import com.semothon.spring_server.user.entity.User;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/rooms")
public class RoomController {

    private final RoomService roomService;

    @GetMapping("/{roomId}")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getRoom(
            @PathVariable Long roomId
    ){
        GetRoomResponseDto getRoomResponseDto = roomService.getRoom(roomId);

        return BaseResponse.success(Map.of("code", 200, "room", getRoomResponseDto.getRoomInfo(), "members", getRoomResponseDto.getMembers(), "host", getRoomResponseDto.getHost()), "room retrieved successfully");
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public BaseResponse createRoom(
            @AuthenticationPrincipal User user,
            @RequestBody @Valid CreateRoomRequestDto requestDto
    ){
        GetRoomResponseDto getRoomResponseDto = roomService.createRoom(user.getUserId(), requestDto);

        return BaseResponse.success(Map.of("code", 201, "room", getRoomResponseDto.getRoomInfo(), "members", getRoomResponseDto.getMembers(), "host", getRoomResponseDto.getHost()), "room created successfully");
    }

    @DeleteMapping("/{roomId}")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse deleteRoom(
            @AuthenticationPrincipal User user,
            @PathVariable Long roomId
    ){
        roomService.deleteRoom(user.getUserId(), roomId);

        return BaseResponse.success(Map.of("code", 200), "room deleted successfully");
    }

    @PostMapping("/{roomId}/join")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse joinRoom(
            @AuthenticationPrincipal User user,
            @PathVariable Long roomId
    ){
        RoomUserInfoDto roomUserInfoDto =  roomService.joinRoom(user.getUserId(), roomId);

        return BaseResponse.success(Map.of("code", 200, "roomUser", roomUserInfoDto), "joined room successfully");
    }

    @PostMapping("/{roomId}/leave")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse leaveRoom(
            @AuthenticationPrincipal User user,
            @PathVariable Long roomId
    ){
        roomService.leaveRoom(user.getUserId(), roomId);

        return BaseResponse.success(Map.of("code", 200), "left room successfully");
    }

}
