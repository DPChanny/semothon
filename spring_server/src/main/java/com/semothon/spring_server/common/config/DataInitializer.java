package com.semothon.spring_server.common.config;

import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.room.entity.RoomUser;
import com.semothon.spring_server.room.entity.RoomUserRole;
import com.semothon.spring_server.room.repository.RoomRepository;
import com.semothon.spring_server.room.repository.RoomUserRepository;
import com.semothon.spring_server.room.repository.UserRoomRecommendationRepository;
import com.semothon.spring_server.user.entity.Gender;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDate;
import java.util.List;

@Configuration
@Slf4j
public class DataInitializer {
    @Bean
    public CommandLineRunner initData(
            UserRepository userRepository,
            RoomRepository roomRepository,
            UserRoomRecommendationRepository userRoomRecommendationRepository,
            RoomUserRepository roomUserRepository){

        return args -> {
            log.info("Initializing test data...");

            //userRepository 에 데이터가 있으면 추가 x
            if (userRepository.count() == 0){
                User user1 = User.builder()
                        .userId("test-user-1")
                        .nickname("tester1")
                        .department("컴퓨터공학과")
                        .studentId("20230001")
                        .birthdate(LocalDate.of(2000, 1, 1))
                        .gender(Gender.MALE)
                        .profileImageUrl("https://example.com/profile1.jpg")
                        .socialProvider("google")
                        .socialId("tester1@example.com")
                        .introText("안녕하세요! 저는 최신 기술과 인공지능에 큰 관심을 가지고 있습니다. 주말에는 가끔 게임을 하며 스트레스를 풀고, 새로운 프로그래밍 언어를 배우는 것을 즐깁니다.")
                        .build();
                userRepository.save(user1);

                User user2 = User.builder()
                        .userId("test-user-2")
                        .nickname("tester2")
                        .department("관광학과")
                        .studentId("20230001")
                        .birthdate(LocalDate.of(2001, 1, 1))
                        .gender(Gender.MALE)
                        .profileImageUrl("https://example.com/profile2.jpg")
                        .socialProvider("google")
                        .socialId("tester2@example.com")
                        .introText("안녕하세요! 저는 여행과 사진 찍는 것을 좋아하는 대학생입니다. 항상 새로운 경험을 찾아 다니며 다양한 사람들과 소통하고 싶습니다.")
                        .build();
                userRepository.save(user2);

                User user3 = User.builder()
                        .userId("test-user-3")
                        .nickname("tester3")
                        .department("문예창작학과")
                        .studentId("20220001")
                        .birthdate(LocalDate.of(1998, 1, 1))
                        .gender(Gender.FEMALE)
                        .profileImageUrl("https://example.com/profile3.jpg")
                        .socialProvider("google")
                        .socialId("tester3@example.com")
                        .introText("저는 영화 감상과 소설 읽기를 좋아하는 대학생입니다. 특히 판타지 장르에 깊은 관심이 있으며, 언젠가는 나만의 이야기를 써보고 싶습니다.")
                        .build();
                userRepository.save(user3);

                User user4 = User.builder()
                        .userId("test-user-4")
                        .nickname("tester4")
                        .department("문화인류학과")
                        .studentId("20220001")
                        .birthdate(LocalDate.of(1995, 1, 1))
                        .gender(Gender.FEMALE)
                        .profileImageUrl("https://example.com/profile4.jpg")
                        .socialProvider("google")
                        .socialId("tester4@example.com")
                        .introText("안녕하세요! 저는 기술과 인문학에 대한 깊은 관심을 가지고 있는 대학생입니다. 주말마다 독서를 즐기고, 가끔은 트레킹을 하면서 자연을 만끽하는 것을 좋아해요.")
                        .build();
                userRepository.save(user4);

                User user5 = User.builder()
                        .userId("test-user-5")
                        .nickname("tester5")
                        .department("외국어학과")
                        .studentId("20210001")
                        .birthdate(LocalDate.of(1997, 1, 1))
                        .gender(Gender.MALE)
                        .profileImageUrl("https://example.com/profile5.jpg")
                        .socialProvider("google")
                        .socialId("tester5@example.com")
                        .introText("안녕하세요! 저는 다양한 문화와 언어에 관심이 많은 학생입니다. 여행과 요리를 즐기며, 새로운 사람들을 만나 이야기하는 것을 좋아해요.")
                        .build();
                userRepository.save(user5);



                // 2. 방 생성 (user1이 호스트)
                Room room1 = Room.builder()
                        .title("현대 미술 토론 모임")
                        .description("이 그룹은 현대 미술에 대한 관심을 공유하는 사람들을 위한 공간입니다. 참여자들은 각자의 경험과 관점을 통해 서로의 창의성을 자극하고, 다양한 전시회 및 워크숍에 참여하여 예술적 감각을 향상시킬 수 있습니다.")
                        .build();
                room1.updateHost(user1);
                roomRepository.save(room1);

                Room room2 = Room.builder()
                        .title("AI 윤리와 기술 발전 연구회")
                        .description("이 그룹은 최신 인공지능 기술의 발전을 연구하고, 그에 따른 윤리적 문제를 논의하기 위해 설립되었습니다. 회원들은 각자의 전문 지식을 공유하며, 세미나와 워크숍을 통해 실질적인 문제 해결 방안을 모색합니다.")
                        .build();
                room2.updateHost(user2);
                roomRepository.save(room2);

                Room room3 = Room.builder()
                        .title("지속 가능한 농업 실천 커뮤니티")
                        .description("이 그룹은 지속 가능한 농업에 관심이 있는 사람들을 위한 플랫폼입니다. 회원들은 친환경 농업 기술을 공유하고, 실내 정원 가꾸기 및 지역 농산물 지원의 중요성을 논의합니다.")
                        .build();
                room3.updateHost(user3);
                roomRepository.save(room3);

                Room room4 = Room.builder()
                        .title("건강한 라이프스타일 실천 모임")
                        .description("이 그룹은 건강한 라이프스타일을 추구하는 사람들을 위한 것입니다. 다양한 운동과 요리 클래스를 통해 서로의 경험을 나누고, 건강한 식습관을 배우며, 즐거운 커뮤니티를 형성하는 것을 목표로 합니다.")
                        .build();
                room4.updateHost(user4);
                roomRepository.save(room4);

                Room room5 = Room.builder()
                        .title("보드게임 즐기는 사람들")
                        .description("이 그룹은 보드게임 애호가들이 모여 다양한 게임을 즐기고 전략을 공유하는 공간입니다. 매월 정기적으로 모임을 가져 새로운 게임을 시도하고, 경험을 나누는 것이 목표입니다.")
                        .build();
                room5.updateHost(user5);
                roomRepository.save(room5);

                // RoomUser 생성 및 저장
                RoomUser ru1_admin = RoomUser.builder()
                        .room(room1)
                        .user(user1)
                        .role(RoomUserRole.ADMIN)
                        .build();

                RoomUser ru1_member1 = RoomUser.builder()
                        .room(room1)
                        .user(user2)
                        .role(RoomUserRole.MEMBER)
                        .build();

                RoomUser ru1_member2 = RoomUser.builder()
                        .room(room1)
                        .user(user3)
                        .role(RoomUserRole.MEMBER)
                        .build();

                RoomUser ru2_admin = RoomUser.builder()
                        .room(room2)
                        .user(user2)
                        .role(RoomUserRole.ADMIN)
                        .build();

                RoomUser ru2_member1 = RoomUser.builder()
                        .room(room2)
                        .user(user1)
                        .role(RoomUserRole.MEMBER)
                        .build();

                RoomUser ru2_member2 = RoomUser.builder()
                        .room(room2)
                        .user(user5)
                        .role(RoomUserRole.MEMBER)
                        .build();

                RoomUser ru3_admin = RoomUser.builder()
                        .room(room3)
                        .user(user3)
                        .role(RoomUserRole.ADMIN)
                        .build();

                RoomUser ru4_admin = RoomUser.builder()
                        .room(room4)
                        .user(user4)
                        .role(RoomUserRole.ADMIN)
                        .build();

                RoomUser ru4_member1 = RoomUser.builder()
                        .room(room4)
                        .user(user1)
                        .role(RoomUserRole.MEMBER)
                        .build();

                RoomUser ru4_member2 = RoomUser.builder()
                        .room(room4)
                        .user(user2)
                        .role(RoomUserRole.MEMBER)
                        .build();

                RoomUser ru4_member3 = RoomUser.builder()
                        .room(room4)
                        .user(user3)
                        .role(RoomUserRole.MEMBER)
                        .build();

                RoomUser ru4_member4 = RoomUser.builder()
                        .room(room4)
                        .user(user5)
                        .role(RoomUserRole.MEMBER)
                        .build();

                RoomUser ru5_admin = RoomUser.builder()
                        .room(room5)
                        .user(user5)
                        .role(RoomUserRole.ADMIN)
                        .build();

                RoomUser ru5_member1 = RoomUser.builder()
                        .room(room5)
                        .user(user1)
                        .role(RoomUserRole.MEMBER)
                        .build();

                roomUserRepository.saveAll(List.of(
                        ru1_admin, ru1_member1, ru1_member2,
                        ru2_admin, ru2_member1, ru2_member2,
                        ru3_admin,
                        ru4_admin, ru4_member1, ru4_member2, ru4_member3, ru4_member4,
                        ru5_admin, ru5_member1
                ));
            } else {
                log.debug("[info] Test User already exists. do not add new Test User");
            }
        };
    }
}
