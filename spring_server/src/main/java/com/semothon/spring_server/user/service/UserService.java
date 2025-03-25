package com.semothon.spring_server.user.service;

import com.semothon.spring_server.user.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class UserService {
    public User findOrCreateUser(String uid, String email) {

        return null;
    }
}
