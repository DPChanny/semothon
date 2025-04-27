package com.semothon.spring_server.user.repository;

import com.semothon.spring_server.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserRepository extends JpaRepository<User, String>, UserRepositoryCustom {
    boolean existsByNickname(String nickname);
}
