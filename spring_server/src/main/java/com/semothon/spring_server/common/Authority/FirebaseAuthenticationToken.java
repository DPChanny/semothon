package com.semothon.spring_server.common.Authority;

import com.semothon.spring_server.user.entity.User;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;

import java.util.Collection;

//SecurityContextHolder 에 저장되는 Authentication 객체를 custom 하게 생성
//Firebase Authentication 을 사용하므로 CustomUserDetails 등을 사용하지 않고, 그냥 바로 User 객체를 principal 로써 저장
public class FirebaseAuthenticationToken extends AbstractAuthenticationToken {
    private final User principal;

    public FirebaseAuthenticationToken(User principal,
                                       Object credentials,
                                       Collection<? extends GrantedAuthority> authorities) {
        super(authorities);
        this.principal = principal;
        setAuthenticated(true);
    }
    @Override
    public Object getCredentials() {
        return null;
    }
    @Override
    public Object getPrincipal() {
        return principal;
    }
}
