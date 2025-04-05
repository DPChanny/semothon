package com.semothon.spring_server.common.config;

import com.semothon.spring_server.chat.dto.ChatRoomInfoDto;
import com.semothon.spring_server.chat.dto.CreateChatRoomRequestDto;
import com.semothon.spring_server.chat.dto.GetChatRoomResponseDto;
import com.semothon.spring_server.chat.entity.ChatMessage;
import com.semothon.spring_server.chat.repository.ChatMessageRepository;
import com.semothon.spring_server.chat.repository.ChatRoomRepository;
import com.semothon.spring_server.crawling.entity.Crawling;
import com.semothon.spring_server.crawling.entity.CrawlingInterest;
import com.semothon.spring_server.crawling.entity.UserCrawlingRecommendation;
import com.semothon.spring_server.crawling.repository.CrawlingRepository;
import com.semothon.spring_server.crawling.repository.UserCrawlingRecommendationRepository;
import com.semothon.spring_server.crawling.service.CrawlingService;
import com.semothon.spring_server.interest.entity.Interest;
import com.semothon.spring_server.interest.repository.InterestRepository;
import com.semothon.spring_server.room.dto.CreateRoomRequestDto;
import com.semothon.spring_server.room.entity.Room;
import com.semothon.spring_server.room.entity.RoomInterest;
import com.semothon.spring_server.room.entity.UserRoomRecommendation;
import com.semothon.spring_server.room.repository.RoomInterestRepository;
import com.semothon.spring_server.room.repository.RoomRepository;
import com.semothon.spring_server.room.repository.UserRoomRecommendationRepository;
import com.semothon.spring_server.room.service.RoomService;
import com.semothon.spring_server.user.entity.Gender;
import com.semothon.spring_server.user.entity.User;
import com.semothon.spring_server.user.entity.UserInterest;
import com.semothon.spring_server.user.repository.UserInterestRepository;
import com.semothon.spring_server.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer {


    private final UserRepository userRepository;
    private final RoomRepository roomRepository;
    private final InterestRepository interestRepository;
    private final RoomInterestRepository roomInterestRepository;
    private final UserInterestRepository userInterestRepository;
    private final UserRoomRecommendationRepository userRoomRecommendationRepository;
    private final CrawlingRepository crawlingRepository;
    private final UserCrawlingRecommendationRepository userCrawlingRecommendationRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final ChatRoomRepository chatRoomRepository;

    private final RoomService roomService;
    private final CrawlingService crawlingService;

    @Transactional
    @EventListener(ApplicationReadyEvent.class)
    public void initData(){
        if(interestRepository.count() == 0){
            List<String> topics = List.of(
                    // 인문계열
                    "윤리학", "형이상학", "존재론", "논리학", "동양철학", "서양철학", "종교철학", "미학", "사회철학", "언어철학",
                    "고전문학", "현대문학", "세계문학", "시", "소설", "희곡", "문학이론", "독서토론", "창작", "문학비평",
                    "한국사", "동양사", "서양사", "세계사", "고고학", "문화사", "전쟁사", "역사학 이론", "역사탐방", "역사 콘텐츠 제작",
                    "음운론", "통사론", "의미론", "화용론", "사회언어학", "언어습득", "음성학", "언어와 인공지능", "언어와 문화", "비교언어학",
                    "민속학", "종교와 문화", "의례", "식문화", "신화", "사회 구조", "문화비평", "현대문화", "제의 문화", "문화 교류",
                    "불교", "기독교", "이슬람", "신화와 종교", "종교철학", "종교사회학", "종교 예술", "동서양 종교 비교", "종교의 역할", "현대 종교",
                    "그리스 로마", "한문고전", "고대문서 해석", "고대사", "철학고전", "고대 예술", "원전읽기", "고문서 연구", "인문학 강독", "역사서 독해",
                    "도서관학", "정보분류", "메타데이터", "디지털아카이브", "기록관리", "정보검색", "정보정책", "데이터 큐레이션", "전자도서관", "독서활동",
                    "발달심리", "인지심리", "사회심리", "상담심리", "성격심리", "심리테스트", "뇌와 심리", "심리 실험", "임상심리", "감정 분석",
                    "영상미학", "미디어비평", "미디어철학", "디지털문화", "스토리텔링", "미디어와 사회", "인터뷰 분석", "신문 콘텐츠 분석", "뉴미디어", "대중문화",

                    // 사회계열
                    "국제정세", "외교정책", "정치사상", "선거제도", "국제기구", "남북관계", "정치 참여", "정치경제학", "국제갈등", "지역분쟁",
                    "거시경제", "미시경제", "행동경제학", "금융경제", "게임이론", "시장구조", "경제모형", "정책평가", "국제경제", "통계경제",
                    "사회문제", "가족구조", "도시사회", "계층문제", "성과 사회", "노동사회학", "사회통계", "사회운동", "문화사회학", "사회이론",
                    "헌법", "형법", "민법", "국제법", "지식재산권", "인권법", "법률해석", "환경법", "노동법", "사법제도",
                    "공공정책", "조직이론", "예산론", "정부조직", "지방행정", "행정개혁", "공공서비스", "전자정부", "정책분석", "인사행정",
                    "뉴스제작", "저널리즘", "방송기획", "여론조사", "광고마케팅", "PR", "미디어윤리", "인터뷰기법", "콘텐츠기획", "디지털미디어",
                    "ODA", "SDGs", "국제 NGO", "공적개발원조", "국제교육", "글로벌 헬스", "재난구호", "개발협력정책", "글로벌 시민", "지속가능 개발",
                    "북한사회", "통일정책", "대북정책", "탈북자 인권", "북한 정치체계", "경제구조", "통일 교육", "문화 교류", "통일 시나리오", "남북협력",
                    "주택시장", "부동산법", "도시계획", "부동산 투자", "개발사업", "공시지가", "토지이용", "부동산 정책", "상업시설", "지역개발",
                    "아동복지", "노인복지", "장애인복지", "청소년복지", "복지정책", "복지시설", "지역사회복지", "사회서비스", "사례관리", "정신건강",

                    // 교육계열
                    "창의수업", "기초문해력", "놀이교육", "독서지도", "협동학습", "수학지도", "초등교육과정", "그림책교육", "생활지도", "교육활동지도안",
                    "교과교육", "논술지도", "학습코칭", "생활지도", "교실운영", "진로지도", "교육심리", "수업컨설팅", "평가방법", "학습자 이해",
                    "놀이중심교육", "감각발달", "언어지도", "유아심리", "발달이론", "부모교육", "창의놀이", "유아교재개발", "유아미술", "유아음악",
                    "장애이해교육", "통합교육", "발달장애", "청각장애", "시각장애", "자폐스펙트럼", "개별화교육계획", "보조공학", "행동지도", "장애유형별 지도",
                    "학습동기", "발달심리", "인지이론", "정서조절", "상담기법", "심리검사", "교육적응", "자기효능감", "성장마인드셋", "수업집중력",
                    "교육정책", "학교운영", "인사관리", "예산편성", "행정정보화", "교육거버넌스", "교육감 리더십", "학사관리", "교육기관 운영", "법규정",
                    "진로탐색", "직업세계이해", "포트폴리오 작성", "진로심리검사", "커리어로드맵", "진로캠프", "진학상담", "창직교육", "진로멘토링", "진로강연",
                    "성인교육", "노인교육", "시민교육", "온라인강의", "교육기획", "학습커뮤니티", "인문교육", "평생학습도시", "평생교육사", "재교육프로그램",
                    "수업설계", "디지털교재", "e러닝", "플립러닝", "교수설계모형", "교육앱", "AI기반학습", "스마트러닝", "VR교육", "교육 데이터 분석",
                    "이중언어교육", "문화다양성", "세계시민교육", "국제학생지원", "다문화가정교육", "문화교류활동", "포용교육", "글로벌리터러시", "편견해소교육", "다문화 이슈",

                    // 공학계열
                    "알고리즘", "데이터구조", "운영체제", "네트워크", "데이터베이스", "시스템프로그래밍", "소프트웨어공학", "클라우드", "분산컴퓨팅", "해킹대응",
                    "머신러닝", "딥러닝", "자연어처리", "컴퓨터비전", "강화학습", "음성인식", "AutoML", "AI윤리", "추천시스템", "생성형 AI",
                    "회로설계", "디지털전자", "아날로그전자", "통신이론", "반도체", "FPGA", "신호처리", "제어공학", "전력전자", "IoT디바이스",
                    "열역학", "유체역학", "CAD", "CAE", "동역학", "재료역학", "메카트로닉스", "로보틱스", "엔진설계", "3D프린팅",
                    "구조역학", "건축재료", "친환경건축", "도시설계", "BIM", "건축CAD", "스마트시티", "주거환경", "시공관리", "건설안전",
                    "지반공학", "구조공학", "수문학", "교통공학", "도시계획", "철도계획", "하천설계", "환경토목", "인프라관리", "도로설계",
                    "품질관리", "생산관리", "시스템최적화", "물류시스템", "인간공학", "공정관리", "산업데이터분석", "시뮬레이션", "SCM", "스마트팩토리",
                    "반응공학", "공정설계", "촉매공학", "에너지공정", "고분자공학", "분리공정", "연료전지", "환경공정", "나노소재", "화학플랜트",
                    "항공역학", "추진공학", "위성기술", "무인기설계", "항법시스템", "항공전자", "우주환경", "로켓시뮬레이션", "드론기술", "위성통신",
                    "자율주행", "로봇비전", "제어시스템", "센서융합", "로봇팔설계", "휴머노이드", "로봇프로그래밍", "ROS", "SLAM", "협동로봇",

                    // 자연계열
                    "미적분학", "선형대수", "확률과 통계", "수리논리", "정수론", "함수해석학", "위상수학", "수학교육", "수학문제풀이", "수리모델링",
                    "고전역학", "양자역학", "전자기학", "열역학", "광학", "입자물리", "응집물질물리", "천체물리", "이론물리", "실험물리",
                    "유기화학", "무기화학", "분석화학", "물리화학", "화학실험", "나노화학", "생화학", "고분자화학", "반응속도론", "환경화학",
                    "유전학", "세포생물학", "분자생물학", "생태학", "진화생물학", "생명공학", "바이러스학", "미생물학", "생물실험", "식물학",
                    "기상학", "지질학", "해양학", "천문학", "기후변화", "지진학", "지형학", "화산학", "대기과학", "우주관측",
                    "기술통계", "추론통계", "회귀분석", "실험설계", "데이터시각화", "베이지안분석", "표본추출", "통계패키지", "시계열분석", "통계모형",
                    "대기오염", "수질관리", "기후정책", "탄소중립", "생물다양성", "환경영향평가", "폐기물관리", "지속가능발전", "환경윤리", "친환경기술",
                    "유전체분석", "단백질구조", "생명정보데이터", "바이오인포매틱스툴", "유전자발현", "오믹스데이터", "DNA분석", "생물DB", "데이터마이닝", "네트워크생물학",
                    "별의진화", "행성탐사", "우주망원경", "블랙홀", "은하계", "우주론", "천체관측", "태양계", "외계행성", "우주탐사",
                    "자연지리", "인문지리", "GIS", "도시지리", "지형분석", "기후지리", "공간데이터", "지역분석", "관광지리", "지리정보시스템",

                    // 의학계열
                    "해부학", "생리학", "병리학", "약리학", "진단학", "내과학", "외과학", "임상술기", "의료윤리", "환자커뮤니케이션",
                    "기본간호", "성인간호", "아동간호", "여성간호", "정신간호", "지역사회간호", "간호과정", "간호실습", "간호윤리", "간호정보학",
                    "치과해부", "교정학", "보철학", "예방치의학", "구강외과", "치과영상", "치주학", "구강보건", "임상실습", "치과재료",
                    "약리학", "제약화학", "임상약학", "조제실습", "약물동태학", "약물상호작용", "생약학", "약품분석", "의약품개발", "약국실습",
                    "한방생리학", "경혈학", "본초학", "침구학", "한방병리학", "한방약리", "진단법", "한방치료법", "한방임상", "한의철학",
                    "근골격재활", "운동치료", "수치료", "신경재활", "물리적 인자", "임상실습", "재활기기", "도수치료", "보행분석", "치료계획",
                    "인지재활", "감각통합", "직업훈련", "일상생활활동", "작업분석", "아동작업치료", "정신작업치료", "장애유형별지도", "환경조정", "기능회복",
                    "응급처치", "외상평가", "심정지처치", "응급약물", "재난의료", "현장응급", "CPR", "트리아지", "이송기술", "응급시뮬레이션",
                    "의료정보", "병원경영", "보험청구", "건강보험", "의료정책", "환자안전", "진료코딩", "전자의무기록", "공공의료", "보건통계",
                    "역학", "건강증진", "감염병관리", "환경보건", "직업보건", "보건통계", "건강정책", "공공보건", "보건교육", "질병예방",

                    // 예체능계열
                    "시각디자인", "UXUI디자인", "제품디자인", "패션디자인", "공간디자인", "브랜딩", "디자인이론", "포스터제작", "디자인툴", "디자인트렌드",
                    "작곡", "연주", "성악", "음악이론", "실용음악", "음악치료", "음악감상", "DAW제작", "악기연주", "음악교육",
                    "회화", "조소", "판화", "설치미술", "미술사", "색채학", "드로잉", "아트워크", "미술비평", "전시기획",
                    "현대무용", "한국무용", "발레", "안무", "무용치료", "무용공연", "신체훈련", "무대동작", "무용교육", "무용역사",
                    "연기훈련", "극작", "무대연출", "연극치료", "즉흥연기", "무대미술", "공연기획", "연극이론", "발성훈련", "대본분석",
                    "시나리오작성", "촬영기법", "영화비평", "영화사", "편집기술", "영상제작", "감독실습", "독립영화", "영화마케팅", "영상미학",
                    "스타일링", "의상제작", "패션마케팅", "패션일러스트", "섬유학", "트렌드분석", "컬렉션기획", "패션브랜드", "패션영상", "패션쇼기획",
                    "스포츠과학", "운동생리학", "스포츠심리", "트레이닝이론", "구기운동", "체력측정", "스포츠윤리", "경기지도", "스포츠마케팅", "체육교육",
                    "영상편집", "유튜브제작", "모션그래픽", "광고영상", "다큐멘터리", "애니메이션", "콘텐츠기획", "촬영기획", "영상시나리오", "미디어툴",
                    "게임기획", "일러스트", "스토리보드", "캐릭터디자인", "게임엔진", "만화콘티", "디지털드로잉", "웹툰제작", "배경디자인", "게임음악"
            );

            for (String topic : topics) {
                interestRepository.save(Interest.builder()
                        .name(topic)
                        .build());
            }
        }

//        if (userRepository.count() == 0){
//            log.info("Initializing test data...");
//            User user1 = User.builder()
//                    .userId("test-user-1")
//                    .name("테스터1")
//                    .nickname("tester1")
//                    .department("컴퓨터공학과")
//                    .studentId("20230001")
//                    .birthdate(LocalDate.of(2000, 1, 1))
//                    .gender(Gender.MALE)
//                    .socialProvider("google")
//                    .socialId("tester1@example.com")
//                    .introText("안녕하세요! 저는 최신 기술과 인공지능에 큰 관심을 가지고 있습니다. 주말에는 가끔 게임을 하며 스트레스를 풀고, 새로운 프로그래밍 언어를 배우는 것을 즐깁니다.")
//                    .shortIntro("AI와 신기술을 사랑하는 개발자 지망생입니다.")
//                    .build();
//            userRepository.save(user1);
//
//            User user2 = User.builder()
//                    .userId("test-user-2")
//                    .name("테스터2")
//                    .nickname("tester2")
//                    .department("관광학과")
//                    .studentId("20230001")
//                    .birthdate(LocalDate.of(2001, 1, 1))
//                    .gender(Gender.MALE)
//                    .socialProvider("google")
//                    .socialId("tester2@example.com")
//                    .introText("안녕하세요! 저는 여행과 사진 찍는 것을 좋아하는 대학생입니다. 항상 새로운 경험을 찾아 다니며 다양한 사람들과 소통하고 싶습니다.")
//                    .shortIntro("여행과 사진을 사랑하는 자유로운 영혼입니다.")
//                    .build();
//            userRepository.save(user2);
//
//            User user3 = User.builder()
//                    .userId("test-user-3")
//                    .name("테스터3")
//                    .nickname("tester3")
//                    .department("문예창작학과")
//                    .studentId("20220001")
//                    .birthdate(LocalDate.of(1998, 1, 1))
//                    .gender(Gender.FEMALE)
//                    .socialProvider("google")
//                    .socialId("tester3@example.com")
//                    .introText("저는 영화 감상과 소설 읽기를 좋아하는 대학생입니다. 특히 판타지 장르에 깊은 관심이 있으며, 언젠가는 나만의 이야기를 써보고 싶습니다.")
//                    .shortIntro("판타지에 빠진 이야기꾼입니다.")
//                    .build();
//            userRepository.save(user3);
//
//            User user4 = User.builder()
//                    .userId("test-user-4")
//                    .name("테스터4")
//                    .nickname("tester4")
//                    .department("문화인류학과")
//                    .studentId("20220001")
//                    .birthdate(LocalDate.of(1995, 1, 1))
//                    .gender(Gender.FEMALE)
//                    .socialProvider("google")
//                    .socialId("tester4@example.com")
//                    .introText("안녕하세요! 저는 기술과 인문학에 대한 깊은 관심을 가지고 있는 대학생입니다. 주말마다 독서를 즐기고, 가끔은 트레킹을 하면서 자연을 만끽하는 것을 좋아해요.")
//                    .shortIntro("책과 자연을 사랑하는 인문학도입니다.")
//                    .build();
//            userRepository.save(user4);
//
//            User user5 = User.builder()
//                    .userId("test-user-5")
//                    .name("테스터5")
//                    .nickname("tester5")
//                    .department("외국어학과")
//                    .studentId("20210001")
//                    .birthdate(LocalDate.of(1997, 1, 1))
//                    .gender(Gender.MALE)
//                    .socialProvider("google")
//                    .socialId("tester5@example.com")
//                    .introText("안녕하세요! 저는 다양한 문화와 언어에 관심이 많은 학생입니다. 여행과 요리를 즐기며, 새로운 사람들을 만나 이야기하는 것을 좋아해요.")
//                    .shortIntro("언어와 문화에 진심인 글로벌 여행러입니다.")
//                    .build();
//            userRepository.save(user5);
//
//            User user6 = User.builder()
//                    .userId("test-user-6")
//                    .name("테스터6")
//                    .nickname("tester6")
//                    .department("환경생명공학과")
//                    .studentId("20210002")
//                    .birthdate(LocalDate.of(1998, 3, 15))
//                    .gender(Gender.FEMALE)
//                    .socialProvider("google")
//                    .socialId("tester6@example.com")
//                    .introText("지구를 지키는 일에 관심이 많은 학생입니다. 플로깅과 업사이클링이 취미이며, 환경 문제에 대해 공부하고 있어요.")
//                    .shortIntro("업사이클링이 취미인 친환경 러버!")
//                    .build();
//
//            User user7 = User.builder()
//                    .userId("test-user-7")
//                    .name("테스터7")
//                    .nickname("tester7")
//                    .department("컴퓨터공학과")
//                    .studentId("20190045")
//                    .birthdate(LocalDate.of(1999, 7, 7))
//                    .gender(Gender.MALE)
//                    .socialProvider("google")
//                    .socialId("tester7@example.com")
//                    .introText("코딩을 사랑하는 개발자 지망생입니다. 요즘은 AI와 백엔드에 푹 빠져 있어요. 토이 프로젝트 같이 해요!")
//                    .shortIntro("디버깅이 취미인 개발자 지망생")
//                    .build();
//
//            User user8 = User.builder()
//                    .userId("test-user-8")
//                    .name("테스터8")
//                    .nickname("tester8")
//                    .department("문헌정보학과")
//                    .studentId("20200234")
//                    .birthdate(LocalDate.of(2000, 11, 12))
//                    .gender(Gender.FEMALE)
//                    .socialProvider("google")
//                    .socialId("tester8@example.com")
//                    .introText("책과 커피를 사랑하는 고양이 집사입니다. 다양한 장르의 책을 좋아하고, 독서모임을 자주 참여해요.")
//                    .shortIntro("고양이와 책을 좋아하는 문학 소녀")
//                    .build();
//
//            User user9 = User.builder()
//                    .userId("test-user-9")
//                    .name("테스터9")
//                    .nickname("tester9")
//                    .department("수학과")
//                    .studentId("20180123")
//                    .birthdate(LocalDate.of(1996, 2, 2))
//                    .gender(Gender.MALE)
//                    .socialProvider("google")
//                    .socialId("tester9@example.com")
//                    .introText("수학 문제를 푸는 걸 좋아하는 조용한 타입입니다. 보드게임과 스도쿠를 자주 즐기고 있어요.")
//                    .shortIntro("보드게임과 수학의 조합이 좋은 사람")
//                    .build();
//
//            User user10 = User.builder()
//                    .userId("test-user-10")
//                    .name("테스터10")
//                    .nickname("tester10")
//                    .department("간호학과")
//                    .studentId("20210101")
//                    .birthdate(LocalDate.of(2001, 5, 5))
//                    .gender(Gender.FEMALE)
//                    .socialProvider("google")
//                    .socialId("tester10@example.com")
//                    .introText("사람을 도와주는 직업에 관심이 많아요. 병원 봉사활동을 자주 하며, 힐링이 되는 대화를 좋아합니다.")
//                    .shortIntro("따뜻한 마음을 가진 힐러 지망생")
//                    .build();
//
//            userRepository.saveAll(List.of(user6, user7, user8, user9, user10));
//
//            Long room1Id = roomService.createRoom(user1.getUserId(), CreateRoomRequestDto.builder()
//                    .title("현대 미술 토론 모임")
//                    .description("이 그룹은 현대 미술에 대한 관심을 공유하는 사람들을 위한 공간입니다. 참여자들은 각자의 경험과 관점을 통해 서로의 창의성을 자극하고, 다양한 전시회 및 워크숍에 참여하여 예술적 감각을 향상시킬 수 있습니다.")
//                    .capacity(10)
//                    .build());
//            Room room1 = roomRepository.findById(room1Id).get();
//            roomService.joinRoom(user2.getUserId(), room1Id);
//            roomService.joinRoom(user3.getUserId(), room1Id);
//            roomService.joinRoom(user4.getUserId(), room1Id);
//            roomService.joinRoom(user5.getUserId(), room1Id);
//
//            Long room2Id = roomService.createRoom(user2.getUserId(), CreateRoomRequestDto.builder()
//                    .title("AI 윤리와 기술 발전 연구회")
//                    .description("이 그룹은 최신 인공지능 기술의 발전을 연구하고, 그에 따른 윤리적 문제를 논의하기 위해 설립되었습니다. 회원들은 각자의 전문 지식을 공유하며, 세미나와 워크숍을 통해 실질적인 문제 해결 방안을 모색합니다.")
//                    .capacity(20)
//                    .build());
//            Room room2 = roomRepository.findById(room2Id).get();
//            roomService.joinRoom(user1.getUserId(), room2Id);
//            roomService.joinRoom(user3.getUserId(), room2Id);
//            roomService.joinRoom(user4.getUserId(), room2Id);
//
//            Long room3Id = roomService.createRoom(user3.getUserId(), CreateRoomRequestDto.builder()
//                    .title("지속 가능한 농업 실천 커뮤니티")
//                    .description("이 그룹은 지속 가능한 농업에 관심이 있는 사람들을 위한 플랫폼입니다. 회원들은 친환경 농업 기술을 공유하고, 실내 정원 가꾸기 및 지역 농산물 지원의 중요성을 논의합니다.")
//                    .capacity(30)
//                    .build());
//            Room room3 = roomRepository.findById(room3Id).get();
//            roomService.joinRoom(user1.getUserId(), room3Id);
//            roomService.joinRoom(user2.getUserId(), room3Id);
//
//
//            Long room4Id = roomService.createRoom(user4.getUserId(), CreateRoomRequestDto.builder()
//                    .title("건강한 라이프스타일 실천 모임")
//                    .description("이 그룹은 건강한 라이프스타일을 추구하는 사람들을 위한 것입니다. 다양한 운동과 요리 클래스를 통해 서로의 경험을 나누고, 건강한 식습관을 배우며, 즐거운 커뮤니티를 형성하는 것을 목표로 합니다.")
//                    .capacity(40)
//                    .build());
//            Room room4 = roomRepository.findById(room4Id).get();
//
//            Long room5Id = roomService.createRoom(user5.getUserId(), CreateRoomRequestDto.builder()
//                    .title("보드게임 즐기는 사람들")
//                    .description("이 그룹은 보드게임 애호가들이 모여 다양한 게임을 즐기고 전략을 공유하는 공간입니다. 매월 정기적으로 모임을 가져 새로운 게임을 시도하고, 경험을 나누는 것이 목표입니다.")
//                    .capacity(50)
//                    .build());
//            Room room5 = roomRepository.findById(room5Id).get();
//            roomService.joinRoom(user10.getUserId(), room5Id);
//            roomService.joinRoom(user9.getUserId(), room5Id);
//            roomService.joinRoom(user8.getUserId(), room5Id);
//            roomService.joinRoom(user7.getUserId(), room5Id);
//            roomService.joinRoom(user6.getUserId(), room5Id);
//
//            Long room11Id = roomService.createRoom(user1.getUserId(), CreateRoomRequestDto.builder()
//                    .title("UX/UI 디자이너들의 감성 충전소")
//                    .description("디자인 트렌드, 포트폴리오 피드백, 브랜딩 아이디어를 나누는 디자이너 전용 공간입니다. 감각 있는 대화를 나누고 협업의 기회를 만들어보세요.")
//                    .capacity(50)
//                    .build());
//            Room room11 = roomRepository.findById(room11Id).get();
//
//            Long room12Id = roomService.createRoom(user1.getUserId(), CreateRoomRequestDto.builder()
//                    .title("사이드 프로젝트 같이 할 사람~?")
//                    .description("기획자, 디자이너, 개발자 모두 모여서 진짜 서비스 하나 같이 만들어보는 공간입니다. 아이디어만 있어도, 코드만 짜도 환영이에요!")
//                    .capacity(50)
//                    .build());
//            Room room12 = roomRepository.findById(room12Id).get();
//
//            Long room13Id = roomService.createRoom(user1.getUserId(), CreateRoomRequestDto.builder()
//                    .title("지구과학 덕후 클럽")
//                    .description("화산, 지진, 기후변화 등 지구과학에 관심 있는 사람들 모여라! 최신 논문 공유부터 자연 다큐 감상까지, 지구를 깊이 탐구하는 공간입니다.")
//                    .capacity(50)
//                    .build());
//            Room room13 = roomRepository.findById(room13Id).get();
//
//            List<String> room1Tags = List.of("머신러닝", "딥러닝", "데이터구조", "윤리학");
//            for (String name : room1Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                RoomInterest ri = RoomInterest.builder().build();
//                ri.updateRoom(room1);
//                ri.updateInterest(interest);
//                roomInterestRepository.save(ri);
//            }
//
//            List<String> room2Tags = List.of("관광지리", "지역분석", "문화교류활동", "윤리학");
//            for (String name : room2Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                RoomInterest ri = RoomInterest.builder().build();
//                ri.updateRoom(room2);
//                ri.updateInterest(interest);
//                roomInterestRepository.save(ri);
//            }
//
//            List<String> room3Tags = List.of("창작", "현대문학", "소설", "윤리학");
//            for (String name : room3Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                RoomInterest ri = RoomInterest.builder().build();
//                ri.updateRoom(room3);
//                ri.updateInterest(interest);
//                roomInterestRepository.save(ri);
//            }
//
//            List<String> room4Tags = List.of("문화비평", "현대문화", "사회철학", "윤리학");
//            for (String name : room4Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                RoomInterest ri = RoomInterest.builder().build();
//                ri.updateRoom(room4);
//                ri.updateInterest(interest);
//                roomInterestRepository.save(ri);
//            }
//
//            List<String> room5Tags = List.of("이중언어교육", "문화다양성", "세계시민교육", "윤리학");
//            for (String name : room5Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                RoomInterest ri = RoomInterest.builder().build();
//                ri.updateRoom(room5);
//                ri.updateInterest(interest);
//                roomInterestRepository.save(ri);
//            }
//
//            List<String> user1Tags = List.of("머신러닝", "딥러닝", "데이터구조", "윤리학");
//            for (String name : user1Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user1);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            List<String> user2Tags = List.of("관광지리", "지역분석", "문화교류활동", "윤리학");
//            for (String name : user2Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user2);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            List<String> user3Tags = List.of("창작", "현대문학", "소설", "윤리학");
//            for (String name : user3Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user3);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            List<String> user4Tags = List.of("문화비평", "현대문화", "사회철학", "윤리학");
//            for (String name : user4Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user4);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            List<String> user5Tags = List.of("이중언어교육", "문화다양성", "세계시민교육", "윤리학");
//            for (String name : user5Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user5);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            List<String> user6Tags = List.of("동양철학", "미학", "언어철학", "사회철학");
//            for (String name : user6Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user6);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            List<String> user7Tags = List.of("머신러닝", "딥러닝", "데이터베이스", "소프트웨어공학");
//            for (String name : user7Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user7);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            List<String> user8Tags = List.of("현대문학", "문학비평", "미디어비평", "스토리텔링");
//            for (String name : user8Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user8);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            List<String> user9Tags = List.of("미적분학", "수리논리", "게임이론", "정수론");
//            for (String name : user9Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user9);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            List<String> user10Tags = List.of("상담심리", "임상심리", "기본간호", "지역사회간호");
//            for (String name : user10Tags) {
//                Interest interest = interestRepository.findByName(name).orElseThrow();
//                UserInterest ui = UserInterest.builder().build();
//                ui.updateUser(user10);
//                ui.updateInterest(interest);
//                userInterestRepository.save(ui);
//            }
//
//            Random random = new Random();
//
//            List<User> users = List.of(user1, user2, user3, user4, user5, user6, user7, user8, user9, user10);
//            List<Room> rooms = List.of(room1, room2, room3, room4, room5);
//
//            for (User user : users) {
//                for (Room room : rooms) {
//                    double score = Math.round((random.nextDouble() * 2 - 1) * 100.0) / 100.0; // -1.0 ~ 1.0, 소수점 2자리
//
//                    UserRoomRecommendation recommendation = UserRoomRecommendation.builder()
//                            .score(score)
//                            .activityScore(score) // 동일한 값으로 설정
//                            .build();
//
//                    recommendation.updateUser(user);
//                    recommendation.updateRoom(room);
//
//                    userRoomRecommendationRepository.save(recommendation);
//                }
//            }
//
//
//
//            Crawling crawling1 = Crawling.builder()
//                    .title("AI로 구현한 새로운 음악 작곡 방식")
//                    .url("https://example.com/articles/ai-music-composition")
//                    .imageUrl("https://example.com/images/ai-music.jpg")
//                    .description("AI를 활용한 작곡 기술이 음악 산업에 어떤 변화를 가져오는지 소개합니다. 창작의 영역이 어떻게 확장되고 있는지 확인해보세요.")
//                    .deadlinedAt(LocalDateTime.of(2025, 12, 20, 14, 30))
//                    .crawledAt(LocalDateTime.now())
//                    .build();
//
//            Crawling crawling2 = Crawling.builder()
//                    .title("기후 변화에 대응하는 도시 설계 전략")
//                    .url("https://example.com/news/climate-smart-cities")
//                    .imageUrl("https://example.com/images/climate-city.jpg")
//                    .description("지속 가능한 도시 개발을 위한 다양한 설계 전략과 그 실제 적용 사례를 분석한 리포트입니다.")
//                    .deadlinedAt(LocalDateTime.of(2025, 11, 10, 10, 0))
//                    .crawledAt(LocalDateTime.now())
//                    .build();
//
//            Crawling crawling3 = Crawling.builder()
//                    .title("청년 세대를 위한 취업 트렌드 리포트 2025")
//                    .url("https://example.com/reports/youth-employment-trends-2025")
//                    .imageUrl("https://example.com/images/employment.jpg")
//                    .description("변화하는 취업 시장에서 청년들이 어떻게 준비하고 대응해야 할지에 대한 심층 분석.")
//                    .deadlinedAt(LocalDateTime.of(2025, 1, 5, 9, 0))
//                    .crawledAt(LocalDateTime.now())
//                    .build();
//
//            Crawling crawling4 = Crawling.builder()
//                    .title("세계 문학을 다시 쓰다 – 여성 작가들의 도전")
//                    .url("https://example.com/columns/women-in-literature")
//                    .imageUrl("https://example.com/images/literature.jpg")
//                    .description("문학사에 새롭게 자리 잡은 여성 작가들의 목소리와 그들이 바꿔가는 이야기들에 대해 다룹니다.")
//                    .deadlinedAt(LocalDateTime.of(2025, 10, 8, 17, 45))
//                    .crawledAt(LocalDateTime.now())
//                    .build();
//
//            Crawling crawling5 = Crawling.builder()
//                    .title("메타버스 속 사회 – 가상공간의 윤리적 고민")
//                    .url("https://example.com/tech/metaverse-ethics")
//                    .imageUrl("https://example.com/images/metaverse.jpg")
//                    .description("메타버스의 확장과 함께 떠오르는 프라이버시, 정체성, 커뮤니티의 윤리적 문제를 짚어봅니다.")
//                    .deadlinedAt(LocalDateTime.of(2025, 9, 15, 12, 15))
//                    .crawledAt(LocalDateTime.now())
//                    .build();
//
//            crawlingRepository.saveAll(List.of(crawling1, crawling2, crawling3, crawling4, crawling5));
//
//            //관심사 추가
//            List<String> crawling1Tags = List.of("머신러닝", "음악이론");
//            List<String> crawling2Tags = List.of("지속가능발전", "도시설계");
//            List<String> crawling3Tags = List.of("진로지도", "직업세계이해");
//            List<String> crawling4Tags = List.of("현대문학", "창작");
//            List<String> crawling5Tags = List.of("AI윤리", "미디어비평");
//
//            List<Crawling> crawlingList = List.of(crawling1, crawling2, crawling3, crawling4, crawling5);
//            List<List<String>> crawlingTagLists = List.of(crawling1Tags, crawling2Tags, crawling3Tags, crawling4Tags, crawling5Tags);
//
//            for (int i = 0; i < crawlingList.size(); i++) {
//                Crawling crawling = crawlingList.get(i);
//                for (String tag : crawlingTagLists.get(i)) {
//                    interestRepository.findByName(tag).ifPresent(interest -> {
//                        CrawlingInterest ci = CrawlingInterest.builder().build();
//                        ci.updateCrawling(crawling);
//                        ci.updateInterest(interest);
//                    });
//                }
//            }
//
//            List<Crawling> crawlings = List.of(crawling1, crawling2, crawling3, crawling4, crawling5);
//
//            for (User user : users) {
//                for (Crawling crawling : crawlings) {
//                    double score = Math.round((random.nextDouble() * 2 - 1) * 100.0) / 100.0; // -1.0 ~ 1.0, 소수점 2자리
//
//                    UserCrawlingRecommendation recommendation = UserCrawlingRecommendation.builder()
//                            .score(score)
//                            .activityScore(score) // 동일한 값으로 설정
//                            .build();
//
//                    recommendation.updateUser(user);
//                    recommendation.updateCrawlingData(crawling);
//
//                    userCrawlingRecommendationRepository.save(recommendation);
//                }
//            }
//
//            GetChatRoomResponseDto chatRoomResponseDto1 = crawlingService.createChatRoom(user6.getUserId(), crawling1.getCrawlingId(),
//                    CreateChatRoomRequestDto.builder()
//                            .title("AI 음악 작곡 토론방")
//                            .description("AI로 작곡한 음악이 정말 예술일까? 음악 산업의 변화와 창작에 대해 이야기해봐요.")
//                            .capacity(10)
//                            .build());
//            Long chatRoom1 = chatRoomResponseDto1.getChatRoomInfo().getChatRoomId();
//            crawlingService.joinChatRoom(user1.getUserId(), crawling1.getCrawlingId(), chatRoom1);
//            crawlingService.joinChatRoom(user2.getUserId(), crawling1.getCrawlingId(), chatRoom1);
//
//            GetChatRoomResponseDto chatRoomResponseDto2 = crawlingService.createChatRoom(user7.getUserId(), crawling2.getCrawlingId(),
//                    CreateChatRoomRequestDto.builder()
//                            .title("기후 변화와 도시 설계")
//                            .description("친환경 도시, 가능할까? 기후 위기에 대응하는 도시의 미래를 함께 고민해요.")
//                            .capacity(15)
//                            .build());
//            Long chatRoom2 = chatRoomResponseDto2.getChatRoomInfo().getChatRoomId();
//            crawlingService.joinChatRoom(user3.getUserId(), crawling2.getCrawlingId(), chatRoom2);
//            crawlingService.joinChatRoom(user4.getUserId(), crawling2.getCrawlingId(), chatRoom2);
//
//            GetChatRoomResponseDto chatRoomResponseDto3 = crawlingService.createChatRoom(user8.getUserId(), crawling3.getCrawlingId(),
//                    CreateChatRoomRequestDto.builder()
//                            .title("취업 트렌드 2025")
//                            .description("요즘 취업시장, 무엇이 달라졌을까? 청년들의 커리어 고민을 함께 나눠요.")
//                            .capacity(12)
//                            .build());
//            Long chatRoom3 = chatRoomResponseDto3.getChatRoomInfo().getChatRoomId();
//            crawlingService.joinChatRoom(user2.getUserId(), crawling3.getCrawlingId(), chatRoom3);
//            crawlingService.joinChatRoom(user6.getUserId(), crawling3.getCrawlingId(), chatRoom3);
//
//            GetChatRoomResponseDto chatRoomResponseDto4 = crawlingService.createChatRoom(user9.getUserId(), crawling4.getCrawlingId(),
//                    CreateChatRoomRequestDto.builder()
//                            .title("여성 작가들의 문학 세계")
//                            .description("문학을 새롭게 써 내려가는 여성 작가들의 이야기를 함께 읽고 나눠요.")
//                            .capacity(8)
//                            .build());
//            Long chatRoom4 = chatRoomResponseDto4.getChatRoomInfo().getChatRoomId();
//            crawlingService.joinChatRoom(user3.getUserId(), crawling4.getCrawlingId(), chatRoom4);
//            crawlingService.joinChatRoom(user1.getUserId(), crawling4.getCrawlingId(), chatRoom4);
//
//            GetChatRoomResponseDto chatRoomResponseDto5 = crawlingService.createChatRoom(user10.getUserId(), crawling5.getCrawlingId(),
//                    CreateChatRoomRequestDto.builder()
//                            .title("메타버스와 윤리")
//                            .description("가상 공간 속 우리는 누구일까? 메타버스 사회에서의 윤리에 대해 토론해요.")
//                            .capacity(10)
//                            .build());
//            Long chatRoom5 = chatRoomResponseDto5.getChatRoomInfo().getChatRoomId();
//            crawlingService.joinChatRoom(user4.getUserId(), crawling5.getCrawlingId(), chatRoom5);
//            crawlingService.joinChatRoom(user7.getUserId(), crawling5.getCrawlingId(), chatRoom5);
//
//            List<User> messageAuthors = List.of(user1, user2, user3, user4, user5);
//            List<String> sampleMessages = List.of(
//                    "안녕하세요, 이 주제 너무 흥미롭네요!",
//                    "AI로 음악을 만든다는 게 정말 신기해요.",
//                    "저는 클래식 작곡에 AI가 어떻게 쓰일 수 있을지 궁금해요.",
//                    "요즘 생성형 AI로 음악도 만들 수 있더라고요.",
//                    "실제로 들어본 적 있는데 꽤 괜찮았어요!"
//            );
//
//            for (int i = 0; i < messageAuthors.size(); i++) {
//                ChatMessage message = ChatMessage.builder()
//                        .message(sampleMessages.get(i))
//                        .createdAt(LocalDateTime.now().minusMinutes(10L * (5 - i))) // 예: 10분 간격 과거 시간
//                        .build();
//                message.updateUser(messageAuthors.get(i));
//                message.updateChatRoom(chatRoomRepository.findById(Long.valueOf(1)).orElseThrow());
//
//                chatMessageRepository.save(message);
//            }
//
//
//        } else {
//            log.info("Test Data already exists. do not add new Test Data");
//        }
    }
}
