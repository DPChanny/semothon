import 'package:flutter/material.dart';
import 'mentoring_room_tab.dart';
import 'activity_room_tab.dart';
import 'package:flutter_app/widgets/custom_tab_bar.dart';

class ChatMentoringPage extends StatefulWidget {
  const ChatMentoringPage({super.key});

  @override
  State<ChatMentoringPage> createState() => _ChatMentoringPageState();
}
class _ChatMentoringPageState extends State<ChatMentoringPage> {
  int _selectedTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  final labels = ['멘토링 방', '활동 방'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 커스텀 탭 바
          CustomTabBar(
            labels: labels,
            selectedIndex: _selectedTabIndex,
            onTabSelected: _onTabSelected,
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: const [
                MentoringRoomTab(),
                ActivityRoomTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

