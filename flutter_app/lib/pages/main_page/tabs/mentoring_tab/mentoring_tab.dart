import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/my_mentor_tab/my_mentor_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/recommended_mentor_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/recommended_room_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/search_tab.dart';
import 'package:flutter_app/widgets/custom_tab_bar.dart';

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
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE4E4E4),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 10),
                    const Text(
                      '멘토 검색',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
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
