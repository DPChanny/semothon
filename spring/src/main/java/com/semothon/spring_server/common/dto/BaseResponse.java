package com.semothon.spring_server.common.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BaseResponse {
    private boolean success;
    private Object data;
    private String message;

    public static BaseResponse success(Object data, String message){
        return new BaseResponse(true, data, message);
    }

    public static BaseResponse failure(Object data, String message){
        return new BaseResponse(false, data, message);
    }
}