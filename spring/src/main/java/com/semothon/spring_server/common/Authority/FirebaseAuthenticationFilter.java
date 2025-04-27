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
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.List;
import java.util.Map;

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
                String profileImageUrl = decodedToken.getPicture(); // 프로필 이미지 URL

                Object firebaseClaim = decodedToken.getClaims().get("firebase");
                String socialProvider = null;

                if (firebaseClaim instanceof Map<?, ?> map) {
                    Object provider = map.get("sign_in_provider");
                    if (provider instanceof String) {
                        socialProvider = (String) provider;
                    }
                }

                User user = userService.findOrCreateUser(uid, socialId, profileImageUrl, socialProvider);

                // Authentication 객체 생성 (기본 권한만 설정)
                List<GrantedAuthority> authorities = List.of(new SimpleGrantedAuthority("ROLE_USER"));
                Authentication authentication = new FirebaseAuthenticationToken(user, null, authorities);
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
