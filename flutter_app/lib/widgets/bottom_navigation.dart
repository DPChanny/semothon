import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/mentoring_page.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationBarWidget({super.key, required this.currentIndex, required this.onTap});

  void _handleTap(BuildContext context, int index) {
    if (index == currentIndex) return; // 같은 탭이면 아무것도 안함

    switch (index) {
      case 0: // 홈
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
        break;
      case 1: // 채팅
        // Navigator.push(context, MaterialPageRoute(builder: (_) => const ChattingPage()));
        break;
      case 2: // 멘토링
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MentoringPage()),
        );
        break;
      case 3: // 추천 활동
        // 다른 페이지로 이동하려면 여기에 추가
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _handleTap(context, index),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: '채팅'),
        BottomNavigationBarItem(icon: Icon(Icons.school), label: '멘토링'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: '추천 활동'),
      ],
    );
  }
}
