import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/recommended_mentor_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/recommended_room_tab.dart';
import 'package:flutter_app/widgets/custom_tab_bar.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/my_mentor_tab.dart';

class MentoringTab extends StatefulWidget {
  const MentoringTab({super.key});

  @override
  State<MentoringTab> createState() => _MentoringTabState();
}

class _MentoringTabState extends State<MentoringTab> {
  int _selectedTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  static const tabLabels = ['추천 멘토', '추천 멘토방', 'My 멘토'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '멘토 검색',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFE4E4E4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          CustomTabBar(
            labels: tabLabels,
            selectedIndex: _selectedTabIndex,
            onTabSelected: _onTabSelected,
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: const [
                RecommendedMentorTab(),
                RecommendedRoomTab(),
                MyMentorTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
