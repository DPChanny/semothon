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

    //권한 부족인 경우
    @ExceptionHandler(ForbiddenException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public BaseResponse unauthorizedException(ForbiddenException ex){
        log.warn("unauthorized error {}", ex.getMessage());

        Map<String, Object> data = new HashMap<>();
        data.put("code", 403);
        data.put("errors", ex.getMessage());

        return BaseResponse.failure(data, "Forbidden task");
    }

    // 그 외 에러
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public BaseResponse defaultException(Exception ex){
        log.error("Unhandled error: ", ex);

        Map<String, String> errors = new HashMap<>();
        errors.put("error", ex.getMessage());

        Map<String, Object> data = new HashMap<>();
        data.put("code", 500);
        data.put("errors", errors);

        return BaseResponse.failure(data, "Unprocessed error");
    }
}
