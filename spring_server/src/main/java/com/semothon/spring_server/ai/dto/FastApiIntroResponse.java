package com.semothon.spring_server.ai.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class FastApiIntroResponse {
    private boolean success;
    private String intro;
    private String message;
}