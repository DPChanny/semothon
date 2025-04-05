package com.semothon.spring_server.user.controller;

import com.semothon.spring_server.ai.service.AiService;
import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.common.service.DateTimeUtil;
import com.semothon.spring_server.user.dto.*;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;
    private final AiService aiService;

    @PostMapping("/login")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse userLogin(
            @AuthenticationPrincipal User user
    ){
        User findUser = userService.getUser(user.getUserId());
        GetUserResponseDto userResponseDto = GetUserResponseDto.from(findUser);

        return BaseResponse.success(Map.of("code", 200, "user", userResponseDto.getUserInfo(), "rooms", userResponseDto.getRooms(), "chatRooms", userResponseDto.getChatRooms()), "Login successful");
    }

    @PostMapping("/check-nickname")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse checkNicknameDuplicate(
            @RequestBody @Valid CheckNicknameRequestDto checkNicknameRequestDto
    ){
        if(userService.checkNickname(checkNicknameRequestDto.getNickname())){
            return BaseResponse.success(Map.of("code", 200, "is_available", true), "nickname is available.");
        }else{
            return BaseResponse.success(Map.of("code", 200, "is_available", false), "nickname already exists.");
        }
    }

    @GetMapping("/profile")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getUserProfile(
            @AuthenticationPrincipal User user
    ){
        User findUser = userService.getUser(user.getUserId());
        GetUserResponseDto userResponseDto = GetUserResponseDto.from(findUser);

        return BaseResponse.success(Map.of("code", 200, "user", userResponseDto.getUserInfo(), "rooms", userResponseDto.getRooms(), "chatRooms", userResponseDto.getChatRooms()), "User profile retrieved successfully");
    }

    @GetMapping("/profile/{userId}")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getOtherUserProfile(
            @AuthenticationPrincipal User currentUser,
            @PathVariable String userId
    ){
        User targetUser = userService.getUser(userId);

        GetUserResponseDto userResponseDto = GetUserResponseDto.from(targetUser);

        return BaseResponse.success(Map.of("code", 200, "user", userResponseDto.getUserInfo(), "rooms", userResponseDto.getRooms(), "chatRooms", userResponseDto.getChatRooms()), "Other user's profile retrieved successfully");
    }

    //나중에 다시 점검
    @GetMapping
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getUserList(
            @AuthenticationPrincipal User user,
            @ModelAttribute @Valid UserSearchCondition condition
    ){
        //default value 명시적 설정
        if (condition.getSortBy() == null) {
            condition.setSortBy(UserSortBy.CREATED_AT);
        }
        if (condition.getSortDirection() == null) {
            condition.setSortDirection(UserSortDirection.DESC);
        }
        if (condition.getPage() == null) {
            condition.setPage(0);
        }
        if (condition.getLimit() == null) {
            condition.setLimit(10);
        }

        //KST 시간을 UTC로 변환
        if(condition.getCreatedAfter() != null){
            condition.setCreatedAfter(DateTimeUtil.convertKSTToUTC(condition.getCreatedAfter()));
        }
        if(condition.getCreatedBefore() != null){
            condition.setCreatedBefore(DateTimeUtil.convertKSTToUTC(condition.getCreatedBefore()));
        }

        List<UserWithScoreDto> userList = userService.getUserList(user.getUserId(), condition);

        List<GetUserListResponseDto> userListResponseDtos =
                userList.stream()
                        .map(u -> GetUserListResponseDto.from(u.user(), u.score()))
                        .toList();

        return BaseResponse.success(Map.of("code", 200, "totalCount", userListResponseDtos.size(), "userList", userListResponseDtos), "Search results retrieved successfully");
    }

    @PatchMapping("/profile")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse updateUserProfile(
            @AuthenticationPrincipal User user,
            @RequestBody @Valid UpdateUserProfileRequestDto profileRequestDto
    ){
        User updatedUser = userService.updateUser(user.getUserId(), profileRequestDto);
        GetUserResponseDto userResponseDto = GetUserResponseDto.from(updatedUser);


        return BaseResponse.success(Map.of("code", 200, "user", userResponseDto.getUserInfo(), "rooms", userResponseDto.getRooms(), "chatRooms", userResponseDto.getChatRooms()), "User profile updated successfully");
    }

    @PutMapping("/interests")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse updateUserInterest(
            @AuthenticationPrincipal User user,
            @RequestBody @Valid UpdateUserInterestRequestDto updateUserInterestRequestDto
    ){
        userService.updateUserInterest(user.getUserId(), updateUserInterestRequestDto);
        String generatedIntroText = aiService.generateIntro(user.getUserId());

        return BaseResponse.success(Map.of("code", 200, "generatedIntroText", generatedIntroText), "Intro text generated successfully");
    }

    @PutMapping("/intro")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse updateUserIntro(
            @AuthenticationPrincipal User user,
            @RequestBody String intro
    ){
        User findUser = userService.getUser(user.getUserId());

        if(StringUtils.hasText(intro)){
            userService.updateUserIntro(findUser.getUserId(), intro);
            aiService.updateInterestByIntroText(findUser.getUserId());
        }
        String finalIntro = aiService.generateIntro(findUser.getUserId());

        userService.updateUserIntro(findUser.getUserId(), finalIntro);

        aiService.updateUserRoomRecommendation(findUser.getUserId());
        aiService.updateUserCrawlingRecommendation(findUser.getUserId());


        return BaseResponse.success(Map.of("code", 200, "userId", findUser.getUserId()), "User intro updated successfully");
    }

    @GetMapping("/profile-image")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse getProfileImage(
            @AuthenticationPrincipal User user
    ){
        String imageUrl =  user.getProfileImageUrl();

        return BaseResponse.success(Map.of("code", 200, "image_url", imageUrl), "Profile image retrieved successfully.");
    }

    @PostMapping("/profile-image")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse updateProfileImage(
            @AuthenticationPrincipal User user,
            @RequestParam("profileImage") MultipartFile profileImage
    ){
        String imageUrl =  userService.uploadProfileImage(user.getUserId(), profileImage);

        return BaseResponse.success(Map.of("code", 200, "image_url", imageUrl), "Profile image uploaded successfully.");
    }

    @DeleteMapping("/profile-image")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse deleteProfileImage(
            @AuthenticationPrincipal User user
    ){
        String imageUrl =  userService.deleteProfileImage(user.getUserId());

        return BaseResponse.success(Map.of("code", 200, "image_url", imageUrl), "Profile image deleted successfully.");
    }
}
