package com.semothon.spring_server.user.dto;

import jakarta.validation.constraints.NotEmpty;
import lombok.*;

import java.util.List;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class UpdateUserInterestRequestDto {
    @NotEmpty(message = "interest must be more than one")
    private List<String> interestNames;
}
