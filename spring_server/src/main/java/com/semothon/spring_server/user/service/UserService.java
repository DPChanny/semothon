package com.semothon.spring_server.user.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.DeleteObjectRequest;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.user.dto.UpdateUserProfileRequestDto;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;


    private final AmazonS3 amazonS3;
    @Value("${cloud.aws.s3.bucket}")
    private String BUCKET_NAME;
    private static final String PROFILE_IMAGE_FOLDER_NAME = "profile-images/";
    private static final String DEFAULT_PROFILE_IMAGE_URL = "https://semothon.s3.ap-northeast-2.amazonaws.com/profile-images/default.png"; //기본 프로필 이미지 URL




    public User findOrCreateUser(String uid, String email, String profileImageUrl, String socialProvider) {
        return userRepository.findById(uid).orElseGet(() -> {
            User newUser = User.builder()
                    .userId(uid)
                    .socialProvider(socialProvider)
                    .socialId(email)
                    .build();

            if(StringUtils.hasText(profileImageUrl)){
                newUser.updateProfileImage(profileImageUrl);
            }

            return userRepository.save(newUser);
        });
    }

    @Transactional(readOnly = true)
    public boolean checkNickname(String nickname) {
        return !userRepository.existsByNickname(nickname);
    }


    public User updateUser(String userId, UpdateUserProfileRequestDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("user not found"));

        if (dto.getNickname() != null &&
                !dto.getNickname().equals(user.getNickname()) &&
                userRepository.existsByNickname(dto.getNickname())) {
            throw new InvalidInputException("Nickname already in use");
        }

        user.updateProfile(dto);
        return user;
    }

    public String uploadProfileImage(String userId, MultipartFile profileImage) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("User not found"));

        if(profileImage == null || profileImage.isEmpty()){
            throw new InvalidInputException("profileImage is empty");
        }

        // 기본 프로필 이미지가 아니면 S3에서 삭제
        if (user.getProfileImageUrl() != null && !user.getProfileImageUrl().equals(DEFAULT_PROFILE_IMAGE_URL)) {
            if(user.getProfileImageUrl().contains(BUCKET_NAME)){
                String oldFilePath = PROFILE_IMAGE_FOLDER_NAME +  user.getProfileImageUrl().substring(user.getProfileImageUrl().lastIndexOf("/") + 1);
                if (amazonS3.doesObjectExist(BUCKET_NAME, oldFilePath)) {
                    amazonS3.deleteObject(new DeleteObjectRequest(BUCKET_NAME, oldFilePath));
                }
            }
        }

        //새로운 사진 이름 지정
        String fileExtension = "";
        int lastDotIndex = profileImage.getOriginalFilename().lastIndexOf(".");
        if(lastDotIndex != -1){
            fileExtension = profileImage.getOriginalFilename().substring(lastDotIndex);
        }
        String newFileName = UUID.randomUUID() + "_" + user.getUserId() + fileExtension;
        String filePath = PROFILE_IMAGE_FOLDER_NAME + newFileName;

        try {
            ObjectMetadata objectMetadata = new ObjectMetadata();
            objectMetadata.setContentType(profileImage.getContentType());
            objectMetadata.setContentLength(profileImage.getSize());

            //S3에 저장
            amazonS3.putObject(new PutObjectRequest(
                            BUCKET_NAME, filePath, profileImage.getInputStream(), objectMetadata
                    )
            );

            //업로드된 이미지 Url
            String imageUrl = amazonS3.getUrl(BUCKET_NAME, filePath).toString();

            // 사용자 프로필 이미지 업데이트
            user.updateProfileImage(imageUrl);
            return imageUrl;
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

    }

    public String deleteProfileImage(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("User not found"));
        
        String currentImage = user.getProfileImageUrl();

        if(currentImage != null && !currentImage.contains(DEFAULT_PROFILE_IMAGE_URL)){
            if(currentImage.contains(BUCKET_NAME)){
                String oldFilePath = PROFILE_IMAGE_FOLDER_NAME +  user.getProfileImageUrl().substring(user.getProfileImageUrl().lastIndexOf("/") + 1);
                if (amazonS3.doesObjectExist(BUCKET_NAME, oldFilePath)) {
                    amazonS3.deleteObject(new DeleteObjectRequest(BUCKET_NAME, oldFilePath));
                }
            }
        }

        user.updateProfileImage(DEFAULT_PROFILE_IMAGE_URL);

        return user.getProfileImageUrl();
    }
}
