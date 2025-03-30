import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/recommended_activity.dart';


//상단 AppBar 생성
AppBar buildAppBar() {
  return AppBar(
    backgroundColor: Colors.grey[300], // 회색 배경
    elevation: 0, // 그림자 제거
    automaticallyImplyLeading: false, // 자동 뒤로가기 아이콘 제거
    title: const Text(
      '브랜드 로고',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.person, color: Colors.black),
        onPressed: (){
          //마이페이지로 이동
        },
      )
    ],
  );
}

//관심분야 카드 생성
Widget interestCard(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  double imageSize = screenWidth * 0.2;

  return Container(
    width: double.infinity,
    color: const Color(0xFF008CFF), // 💙 진한 파란색 배경
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 60),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 텍스트와 프로필
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '나의 관심분야는?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // 🔥 흰색
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '나의 현재 관심사를 확인하고\n수정해 보세요.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // 프로필 이미지
            Container(
              width: 80,
              height: 80,
              margin: const EdgeInsets.only(top: 24),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage('https://randomuser.me/api/portraits/women/75.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
  
        // 키워드 태그들
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Chip 리스트
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: const [
                  KeywordChip(text: '개발'),
                  KeywordChip(text: 'UX'),
                  KeywordChip(text: '프론트'),
                  KeywordChip(text: '프론트'),
                  KeywordChip(text: '그래픽 디자인'),
                  KeywordChip(text: 'UI'),
                ],
              ),

          

              // 🔹 화살표 아이콘을 오른쪽 하단에
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('관심분야 수정'),
                          content: const Text('관심분야를 수정하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // TODO: 수정 로직
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          )
      ],
    ),
  );
}

//관심분야 박스
class KeywordChip extends StatelessWidget {
  final String text;

  const KeywordChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white, // 💡 글자색 확실하게 지정!
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

//추천 멘토리스트 생성
Widget recommendedMentorList() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 0),
          spreadRadius: 2
        )
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '추천 멘토 List',
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        // 🔽 멘토 리스트 반복
        Column(
          children: List.generate(3, (index) => mentorItem()),
        )
      ],
    ),
  );
}
Widget mentorItem() {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 🖼 프로필 이미지
        const CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage('https://randomuser.me/api/portraits/women/75.jpg'),
        ),
        const SizedBox(width: 12),

        // 👤 이름 + 전공
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '날라다니는 전자맨',
                style: TextStyle(
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.29,
                  fontSize: 17,
                ),
              ),
              Text(
                '전자정보학과 4학년입니다.',
                style: TextStyle(
                  color: Color(0xFF888888),
                  fontSize: 12,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.20,
                ),
              ),
            ],
          ),
        ),

        // 📦 버튼
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE4E4E4),
            foregroundColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            
            elevation: 4,
          ),
          child: const Text(
            '알아보기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 13,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.22,
            ),
          ),
        )
      ],
    ),
  );
}


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget bottomNavigationBarWidget() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: '채팅',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '멘토링',
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        appBar: buildAppBar(),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  interestCard(context),
                  recommendedMentorList(),
                  const SizedBox(height: 10),
                  
                  RecommendCardSlider(),
                   // 이후 콘텐츠 자리
                ],
              ),
            ),

            // 🌟 파란 카드에 겹쳐서 보일 추천 멘토 리스트
           
          ],
        ),
        bottomNavigationBar: bottomNavigationBarWidget(),
      ),
    );
  }

}
