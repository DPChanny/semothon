package com.semothon.spring_server.user.repository;

import com.semothon.spring_server.user.dto.UserSearchCondition;
import com.semothon.spring_server.user.entity.User;

import java.util.List;

public interface UserRepositoryCustom {

    List<User> searchUserList(UserSearchCondition condition, String currentUserId);
}
