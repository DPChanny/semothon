package com.semothon.spring_server.user.dto;

import com.semothon.spring_server.user.entity.Gender;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.*;

import java.time.LocalDate;

@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class UpdateUserProfileRequestDto {
    private String name;

    @Size(min = 2, max = 20, message = "Nickname must be between 2 and 20 characters")
    @Pattern(regexp = "^[a-zA-Z0-9가-힣-_]+$", message = "Nickname can only contain Korean, English letters, numbers, underscores, and dashes")
    private String nickname;

    private String department;

    private String studentId;

    private LocalDate birthdate;

    private Gender gender;

    private String shortIntro;
}
