import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/room_chatting_tab.dart';
import 'package:flutter_app/widgets/custom_tab_bar.dart';

import 'tabs/activity_chatting_tab.dart';

class ChattingTab extends StatefulWidget {
  const ChattingTab({super.key});

  @override
  State<ChattingTab> createState() => _ChattingTabState();
}

class _ChattingTabState extends State<ChattingTab> {
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
              children: const [RoomChattingTab(), ActivityChattingTab()],
            ),
          ),
        ],
      ),
    );
  }
}
