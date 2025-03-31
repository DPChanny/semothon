import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_dto.dart';
import 'package:flutter_app/services/fetch_mentors.dart';
import 'package:flutter_app/widgets/mentor_item.dart';

import 'package:flutter_app/dto/crawling_dto.dart';
import 'package:flutter_app/services/fetch_crawlings.dart';
import 'package:flutter_app/services/fetch_user.dart';
import 'package:flutter_app/widgets/crawling_item.dart';
import 'package:flutter_app/widgets/interest_card.dart';
import 'package:flutter_app/pages/mentoring_page.dart';
import 'package:flutter_app/widgets/bottom_navigation.dart';


AppBar buildAppBar(String title) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.person, color: Colors.grey),
        onPressed: () {
          //마이페이지로 이동
        },
      ),
      IconButton(
        icon: Icon(Icons.settings, color: Colors.grey),
        onPressed: () {
          //설정 이동
        },
      ),
    ],
  );
}

Widget buildInterestCard() {
  return FutureBuilder<(UserDTO, List<String>)>(
    future: fetchUser(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (!snapshot.hasData) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: Text('데이터를 불러오는 데 실패했습니다.')),
        );
      }

      final (user, keywords) = snapshot.data!;
      return interestCard(context, user, keywords);
    },
  );
}

Widget buildMentorsCard() {
  return FutureBuilder<List<UserDTO>>(
    future: fetchMentors(3),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(
          height: 500, // 공간 확보 (optional)
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox(
          height: 500, // 공간 확보 (optional)
          child: Center(child: Text('데이터를 불러오는 데 실패했습니다.')),
        );
      }

      final mentors = snapshot.data!;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 0),
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 텍스트 부분
                Expanded(
                  child: Text(
                    '추천 멘토 List',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                // 아이콘 부분
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.blue, // 🔹 파란색
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: mentors.map((mentor) => mentorItem(mentor)).toList(),
            ),
          ],
        ),
      );
    },
  );
}

Widget buildCrawlingsCard() {
  return FutureBuilder<List<CrawlingDto>>(
    future: fetchCrawlingItems(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(
          height: 180,
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const SizedBox(
          height: 180,
          child: Center(child: Text('추천 활동이 없습니다.')),
        );
      }

      final items = snapshot.data!;
      final PageController pageController = PageController(
        viewportFraction: 0.85,
      );

      return SizedBox(
        height: 200,
        child: PageView.builder(
          controller: pageController,
          itemCount: items.length,
          itemBuilder: (context, index) {
            return crawlingItem(context, items[index]);
          },
        ),
      );
    },
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // 탭별 화면 위젯들
  final List<Widget> _pages = [
    // 홈 탭
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInterestCard(), // 관심 카드
          Transform.translate(
            offset: Offset(0, -90),
            child: Column(
              children: [
                buildMentorsCard(), // 멘토 리스트

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 텍스트 부분
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '추천 활동',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '관심사 분석을 통해 세모님의 맞춤형 활동을 추천합니다.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 아이콘 부분
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.blue, // 🔹 파란색
                      ),
                    ],
                  ),
                ),

                buildCrawlingsCard(),
              ],
            ),
          ),
        ],
      ),
    ),

  ];

  void _onTap(int index) {
  if (index == 2) {
    // 멘토링 탭은 push로 이동
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MentoringPage()),
    );
    return; // selectedIndex는 변경하지 않음
  }

  setState(() {
    _selectedIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar("브랜드이름"),
        body: _pages[_selectedIndex], // 현재 탭의 화면
        bottomNavigationBar: BottomNavigationBarWidget(
          currentIndex: _selectedIndex,
          onTap: _onTap,
        ),
      ),
    );
  }
}
