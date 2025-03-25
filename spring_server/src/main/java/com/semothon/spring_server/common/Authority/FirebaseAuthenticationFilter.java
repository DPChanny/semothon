package com.semothon.spring_server.common.Authority;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.service.UserService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.InsufficientAuthenticationException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class FirebaseAuthenticationFilter  extends OncePerRequestFilter {

    private final FirebaseAuth firebaseAuth;
    private final UserService userService;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String idToken = resolveToken(request);

        if(StringUtils.hasText(idToken)){
            try {
                FirebaseToken decodedToken = firebaseAuth.verifyIdToken(idToken);
                String uid = decodedToken.getUid();
                String socialId = decodedToken.getEmail();

                log.info("Firebase Token verified - FirebaseToken {}", decodedToken);

                // 유저 조회 or 최초 로그인 등록 <- decodedToken에 포함된 정보 확인 후 파라미터 추가
                User user = userService.findOrCreateUser(uid, socialId);

                // Authentication 객체 생성 (권한 없이 기본 설정)
                Authentication authentication = new FirebaseAuthenticationToken(user, null, List.of());
                SecurityContextHolder.getContext().setAuthentication(authentication);

            } catch (FirebaseAuthException e) {
                log.warn("Firebase token invalid: {}", e.getMessage());
                throw new InsufficientAuthenticationException("Invalid Firebase ID Token", e);
            }catch (Exception e) {
                log.error("Unexpected error during Firebase authentication", e);
                throw new InsufficientAuthenticationException("Unexpected authentication error", e);
            }
        }
        filterChain.doFilter(request, response);
    }

    private String resolveToken(HttpServletRequest request){
        String bearerToken = request.getHeader("Authorization");
        if(StringUtils.hasText(bearerToken) && bearerToken.startsWith("Bearer ")){
            return bearerToken.substring(7);
        }
        return null;
    }
}
