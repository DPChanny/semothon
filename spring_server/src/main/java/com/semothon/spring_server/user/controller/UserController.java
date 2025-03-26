package com.semothon.spring_server.user.controller;

import com.semothon.spring_server.common.dto.BaseResponse;
import com.semothon.spring_server.user.dto.CheckNicknameRequestDto;
import com.semothon.spring_server.user.dto.GetUserResponseDto;
import com.semothon.spring_server.user.dto.UpdateUserProfileRequestDto;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.service.UserService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.Map;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    @PostMapping("/login")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse userLogin(
            @AuthenticationPrincipal User user
    ){
        return BaseResponse.success(Map.of("code", 200, "user", GetUserResponseDto.from(user)), "Login successful");
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
        return BaseResponse.success(Map.of("code", 200, "user", GetUserResponseDto.from(user)), "User profile retrieved successfully");
    }

    @PatchMapping("/profile")
    @ResponseStatus(HttpStatus.OK)
    public BaseResponse updateUserProfile(
            @AuthenticationPrincipal User user,
            @RequestBody @Valid UpdateUserProfileRequestDto profileRequestDto
    ){
        User updatedUser = userService.updateUser(user.getUserId(), profileRequestDto);

        return BaseResponse.success(Map.of("code", 200, "user", GetUserResponseDto.from(updatedUser)), "User profile updated successfully");
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
