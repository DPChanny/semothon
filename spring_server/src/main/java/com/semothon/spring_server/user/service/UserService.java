package com.semothon.spring_server.user.service;

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

}
