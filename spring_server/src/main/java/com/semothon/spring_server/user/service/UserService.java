package com.semothon.spring_server.user.service;

import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.user.dto.UpdateUserProfileRequestDto;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public User findOrCreateUser(String uid, String email, String profileImageUrl, String socialProvider) {
        return userRepository.findById(uid).orElseGet(() -> {
            User newUser = User.builder()
                    .userId(uid)
                    .profileImageUrl(profileImageUrl)
                    .socialProvider(socialProvider)
                    .socialId(email)
                    .build();
            return userRepository.save(newUser);
        });
    }

    @Transactional(readOnly = true)
    public boolean checkNickname(String nickname) {
        return !userRepository.existsByNickname(nickname);
    }


    public User updateUser(String userId, UpdateUserProfileRequestDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));

        if (dto.getNickname() != null &&
                !dto.getNickname().equals(user.getNickname()) &&
                userRepository.existsByNickname(dto.getNickname())) {
            throw new InvalidInputException("Nickname already in use");
        }

        user.updateProfile(dto);
        return user;
    }
}
