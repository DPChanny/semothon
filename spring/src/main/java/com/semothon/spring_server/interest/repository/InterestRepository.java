package com.semothon.spring_server.interest.repository;

import com.semothon.spring_server.interest.entity.Interest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface InterestRepository extends JpaRepository<Interest, Long> {
    Optional<Interest> findByName(String name);
    List<Interest> findAllByNameIn(List<String> names);
}
