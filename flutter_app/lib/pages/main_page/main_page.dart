import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/chatting_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/crawling_tab/crawling_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/home_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/mentoring_tab.dart';

import 'package:flutter_app/pages/my_pages/my_page.dart';
import 'package:flutter_app/routes/chat_page_routes.dart';
import 'package:flutter_app/routes/mentoring_tab_routes.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainPage extends StatefulWidget {
  final int currentIndex;

  const MainPage({super.key, this.currentIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

  late final List<Widget> _pages;
  late final List<VoidCallback?> _onSearchPressedHandlers;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int) {
        setState(() {
          _selectedIndex = args;
        });
      }
    });

    _pages = [
      HomeTab(onTabChange: _onTap),
      ChattingTab(onTabChange: _onTap),
      const MentoringTab(),
      CrawlingTab(),
    ];

    _onSearchPressedHandlers = [
      null,
          () {
        Navigator.pushNamed(context, ChatPageRouteNames.searchChattingPage);
      },
          () {
        Navigator.pushNamed(context, MyMentorTabRouteNames.searchPage);
      },
      null
    ];
  }

  void _onTap(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _appBarTitles = [
    "",
    "채팅",
    "멘토링",
    "추천 활동",
  ];

  String _getAppBarTitle(int index) {
    return _appBarTitles[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
          title: _selectedIndex == 0
              ? SvgPicture.asset(
            'assets/logo.svg', // 👈 로고 경로 (예시, 네 파일 이름에 맞게)
            height: 24,
          )
              : Text(
            _getAppBarTitle(_selectedIndex),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        actions: [
          if (_onSearchPressedHandlers[_selectedIndex] != null)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () {
                _onSearchPressedHandlers[_selectedIndex]!.call();
              },
            ),
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
                builder: (context) => MyPage(user: result.user!.userInfo, chatRooms: result.user!.chatRooms,),
              ),
            );
          },
        ),
        ]
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/widget_icon/home_icon.svg',
              width: 27,
              height: 27,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'assets/widget_icon/home_icon.svg',
              width: 27,
              height: 27,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/widget_icon/chat_icon.svg',
              width: 27,
              height: 27,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'assets/widget_icon/chat_icon.svg',
              width: 27,
              height: 27,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            label: '채팅',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/widget_icon/mentoring_icon.svg',
              width: 27,
              height: 27,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'assets/widget_icon/mentoring_icon.svg',
              width: 27,
              height: 27,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            label: '멘토링',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/widget_icon/recommended_icon.svg',
              width: 27,
              height: 27,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
            activeIcon: SvgPicture.asset(
              'assets/widget_icon/recommended_icon.svg',
              width: 27,
              height: 27,
              colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
            ),
            label: '추천 활동',
          ),
        ],
      ),
    );
  }
}
