package com.semothon.spring_server.common.config.Interceptor;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import java.util.List;
import java.util.Map;

/**
 * WebSocket 핸드쉐이크 과정에서 수행되는 인터셉터
 * Firebase Id Token 인증 및 인증 된 User 를 세션에 전달하는 역할
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class AuthHandshakeInterceptor implements HandshakeInterceptor {

    private final FirebaseAuth firebaseAuth;

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler, Map<String, Object> attributes) {

        String token = resolveToken(request);

        if (token == null || token.isEmpty()) { //토큰 추출 실패 시 401에러 반환
            response.setStatusCode(HttpStatus.UNAUTHORIZED);
            return false;
        }

        try {
            // 2. Firebase 토큰 검증
            FirebaseToken decodedToken = firebaseAuth.verifyIdToken(token);

            // 3. userId를 WebSocketSession 에 저장
            attributes.put("userId", decodedToken.getUid());

            return true;

        } catch (FirebaseAuthException e) {
            log.warn("WebSocket 토큰 인증 실패: {}", e.getMessage());
            response.setStatusCode(HttpStatus.UNAUTHORIZED);
            return false;
        }
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response, WebSocketHandler wsHandler, Exception exception) {
        //별도처리 x
    }

    private String resolveToken(ServerHttpRequest request){

        // 헤더에서 토큰 추출 (Authorization: Bearer xxx)
        List<String> authHeaders = request.getHeaders().get("Authorization");
        if (authHeaders != null && !authHeaders.isEmpty()) {
            String header = authHeaders.get(0);
            if (header.startsWith("Bearer ")) {
                return header.substring(7);
            }
        }
        return null;
    }
}
