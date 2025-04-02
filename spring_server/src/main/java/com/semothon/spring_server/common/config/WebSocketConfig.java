package com.semothon.spring_server.common.config;

import com.semothon.spring_server.common.config.handler.AuthHandshakeInterceptor;
import com.semothon.spring_server.common.config.handler.ChatWebSocketHandler;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

/**
 * WebSocket 엔트포인트와 핸들러 등록을 위한 Config
 * 즉 클라이언트가 WebSocket 연결을 위한 엔드포인트를 설정하는 역할
 */
@Slf4j
@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class WebSocketConfig implements WebSocketConfigurer {

    private final ChatWebSocketHandler chatWebSocketHandler;
    private final AuthHandshakeInterceptor authHandshakeInterceptor;

    /**
     * 기본 WebSocket 설정 구성
     * 핸들러를 특정 엔드포인트에 매핑
     */
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        log.info("최초 WebSocket 연결을 위한 Handler 등록");

        registry.addHandler(chatWebSocketHandler, "/ws-stomp") //핸들러 등록, /ws-chat 으로 접근시 chatWebSocketHandler 가 받아서 처리
                .setAllowedOrigins("*") //모든 도메인에 대한 접근 허용
                .addInterceptors(authHandshakeInterceptor) // WebSocket 핸드쉐이크 과정에 인터셉트 추가 -> WebSocket 연길 시 핸드 쉐이크 과정에서 firebase의 IdToken 검증 및, 검증 된 유저 정보를 세션에서 활용하기 위함, Spring Security 경우 REST 요청에는 정상동작하지만,  WebSocket 핸드셰이크 시점의 토큰 처리에서는 수행되지 않는듯
                .withSockJS(); // WebSocket 미지원 브라우저 fallback
    }
}
