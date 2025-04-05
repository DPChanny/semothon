import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/chatting_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/home_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/mentoring_tab.dart';
import 'package:flutter_app/pages/my_page.dart';
import 'package:flutter_app/services/queries/user_query.dart';

class MainPage extends StatefulWidget {
  final int currentIndex;

  const MainPage({super.key, this.currentIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onTap(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = const [
    HomeTab(),
    ChattingTab(),
    MentoringTab(),
    Center(child: Text("추천 활동")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "브랜드이름",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
        IconButton(
          icon: const Icon(Icons.person, color: Colors.grey),
          onPressed: () async {
            final result = await getUser();

            if (!result.success || result.user == null) {
              // 실패 처리 (예: 에러 토스트 등)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("유저 정보를 불러오지 못했습니다.")),
              );
              return;
            }

            // 유저 정보 가져오기에 성공하면 페이지 이동
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyPageHeader(user: result.user!.userInfo, chatRooms: result.user!.chatRooms,),
              ),
            );
          },
        ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: '멘토링'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: '추천 활동'),
        ],
      ),
    );
  }
}
