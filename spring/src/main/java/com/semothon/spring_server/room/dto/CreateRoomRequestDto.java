package com.semothon.spring_server.room.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.*;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class CreateRoomRequestDto {
    @NotEmpty(message = "title is required")
    private String title;

    @NotEmpty(message = "description is required")
    private String description;

    @Min(value = 2, message = "Minimum capacity is 2")
    @Max(value = 100, message = "Maximum capacity is 100")
    private Integer capacity;
}
