package com.semothon.spring_server.room.controller;

import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.room.dto.*;
import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.room.service.RoomService;
import com.semothon.spring_server.user.dto.GetUserResponseDto;
import com.semothon.spring_server.user.entity.User;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
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

    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getRoomList(
            @AuthenticationPrincipal User user,
            @ModelAttribute @Valid RoomSearchCondition condition
    ){
        //default value 명시적 설정
        if (condition.getSortBy() == null) {
            condition.setSortBy(RoomSortBy.CREATED_AT);
        }
        if (condition.getSortDirection() == null) {
            condition.setSortDirection(RoomSortDirection.DESC);
        }
        if (condition.getPage() == null) {
            condition.setPage(0);
        }
        if (condition.getSize() == null) {
            condition.setSize(10);
        }

        //KST 시간을 UTC로 변환
        if(condition.getCreatedAfter() != null){
            condition.setCreatedAfter(DateTimeUtil.convertKSTToUTC(condition.getCreatedAfter()));
        }
        if(condition.getCreatedBefore() != null){
            condition.setCreatedBefore(DateTimeUtil.convertKSTToUTC(condition.getCreatedBefore()));
        }

        List<Room> roomList = roomService.getRoomList(user.getUserId(), condition);

        List<GetRoomListResponseDto> roomListResponseDtos =
                roomList.stream()
                .map(GetRoomListResponseDto::from)
                        .toList();

        return BaseResponse.success(Map.of("code", 200, "totalCount", roomListResponseDtos.size(), "roomList", roomListResponseDtos), "Search results retrieved successfully");
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
