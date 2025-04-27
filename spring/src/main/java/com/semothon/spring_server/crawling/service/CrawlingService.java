package com.semothon.spring_server.crawling.service;

import com.semothon.spring_server.chat.dto.ChatRoomInfoDto;
import com.semothon.spring_server.chat.dto.CreateChatRoomRequestDto;
import com.semothon.spring_server.chat.dto.GetChatRoomResponseDto;
import com.semothon.spring_server.chat.dto.UpdateChatRoomRequestDto;
import com.semothon.spring_server.chat.service.ChatRoomService;
import com.semothon.spring_server.common.exception.InvalidInputException;
import com.semothon.spring_server.crawling.dto.CrawlingSearchCondition;
import com.semothon.spring_server.crawling.dto.CrawlingWithScoreDto;
import com.semothon.spring_server.crawling.dto.GetCrawlingResponseDto;
import com.semothon.spring_server.crawling.entity.Crawling;
import com.semothon.spring_server.crawling.repository.CrawlingRepository;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@Transactional
@RequiredArgsConstructor
public class CrawlingService {
    private final CrawlingRepository crawlingRepository;
    private final UserRepository userRepository;
    private final ChatRoomService chatRoomService;

    @Transactional(readOnly = true)
    public GetCrawlingResponseDto getCrawling(Long crawlingId) {
        Crawling crawling = crawlingRepository.findById(crawlingId)
                .orElseThrow(() -> new InvalidInputException("crawling not found"));
        return GetCrawlingResponseDto.from(crawling);


    }

    @Transactional(readOnly = true)
    public List<CrawlingWithScoreDto> getCrawlingList(String userId, CrawlingSearchCondition condition) {
        return crawlingRepository.searchCrawlingList(condition, userId);
    }

    public GetChatRoomResponseDto createChatRoom(String userId, Long crawlingId, CreateChatRoomRequestDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("User not found"));
        Crawling crawling = crawlingRepository.findById(crawlingId)
                .orElseThrow(() -> new InvalidInputException("Crawling not found"));

        return chatRoomService.createCrawlingChat(crawling, user, dto.getTitle(), dto.getDescription(), dto.getCapacity());
    }

    public GetChatRoomResponseDto updateChatRoom(String userId, Long crawlingId, Long chatRoomId, UpdateChatRoomRequestDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("User not found"));

        return chatRoomService.updateChatRoom(chatRoomId,user, dto);
    }

    public void deleteChatRoom(String userId, Long crawlingId, Long chatRoomId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("User not found"));

        chatRoomService.deleteChatRoom(chatRoomId, user);
    }

    public GetChatRoomResponseDto joinChatRoom(String userId, Long crawlingId, Long chatRoomId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("User not found"));

        return chatRoomService.joinChatRoom(chatRoomId, user);
    }

    public void leaveChatRoom(String userId, Long crawlingId, Long chatRoomId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new InvalidInputException("User not found"));

        chatRoomService.leaveChatRoom(chatRoomId, user);
    }
}
