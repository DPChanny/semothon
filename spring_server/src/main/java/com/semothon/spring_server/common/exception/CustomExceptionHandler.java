package com.semothon.spring_server.common.exception;

import com.semothon.spring_server.common.dto.BaseResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@RestControllerAdvice
public class CustomExceptionHandler {

    //validation failed
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public BaseResponse handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, Object> errors = new HashMap<>();

        ex.getBindingResult().getFieldErrors().forEach(error -> {
            errors.put(error.getField(), error.getDefaultMessage());
        });

        Map<String, Object> data = new HashMap<>();
        data.put("code", 400);
        data.put("errors", errors);

        return BaseResponse.failure(data, "Validation failed.");
    }

    //DB 조회 결과 잘못된 입력인 경우
    @ExceptionHandler(InvalidInputException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public BaseResponse invalidInputException(InvalidInputException ex){
        log.warn("Invalid input error: {}", ex.getMessage());

        Map<String, Object> data = new HashMap<>();
        data.put("code", 400);
        data.put("errors", ex.getMessage());

        return BaseResponse.failure(data, "Invalid input");
    }
}
