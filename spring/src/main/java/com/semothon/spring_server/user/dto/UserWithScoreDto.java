package com.semothon.spring_server.user.dto;

import com.semothon.spring_server.user.entity.User;

public record UserWithScoreDto(User user, Double score) {
}
