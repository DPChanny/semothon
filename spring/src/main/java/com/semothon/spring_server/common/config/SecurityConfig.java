package com.semothon.spring_server.common.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.semothon.spring_server.common.Authority.FirebaseAuthenticationFilter;
import com.semothon.spring_server.common.dto.BaseResponse;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;
import java.util.Map;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final FirebaseAuthenticationFilter firebaseAuthenticationFilter;
    private final ObjectMapper objectMapper = new ObjectMapper();

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .sessionManagement(config -> config.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(
                                "/api/users/check-nickname",
                                "/ws-stomp" //ws에 대한 인증은 handshake과정에서 별도로 검증
                        ).permitAll() // 인증없이 접근 가능한 api 목록
                        .requestMatchers(
                                "/api/private/**"
                        ).authenticated() //인증이 필요한 api 목록
                        .anyRequest().authenticated() // 이외의 모든 api에 대해 인증 필요
                )
                .addFilterBefore(firebaseAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .exceptionHandling(ex -> ex // 예외 핸들링
                        .authenticationEntryPoint(authenticationEntryPoint())
                        .accessDeniedHandler(accessDeniedHandler())
                )
                .build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration config = new CorsConfiguration();
        config.setAllowCredentials(true);                     // Authorization 헤더 & 쿠키 허용
        config.addAllowedOriginPattern("*");                  // 모든 Origin 허용
        config.addAllowedHeader("*");                         // 모든 헤더 허용
        config.addAllowedMethod("*");                         // GET, POST, PUT 등 모든 HTTP 메서드 허용
        config.setExposedHeaders(List.of("Authorization"));   // 응답 헤더 중 클라이언트가 읽을 수 있는 항목, 필요 시 추가

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", config);      // 모든 경로에 위 설정 적용
        return source;
    }

    // 인증 실패 에러 처리
    @Bean
    public AuthenticationEntryPoint authenticationEntryPoint() {
        return (request, response, ex) -> {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            BaseResponse errorResponse = BaseResponse.failure(
                    Map.of("code", 401, "id_token", "id_token is not valid"),
                    "Authentication failed. Please provide a valid token."
            );
            response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
        };
    }

    // 권한 부족 예외 처리
    @Bean
    public AccessDeniedHandler accessDeniedHandler() {
        return (request, response, accessDeniedException) -> {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            BaseResponse errorResponse = BaseResponse.failure(
                    Map.of("code", 403),
                    "Access denied. You do not have permission to access this resource."
            );

            response.getWriter().write(objectMapper.writeValueAsString(errorResponse));
        };
    }
}
