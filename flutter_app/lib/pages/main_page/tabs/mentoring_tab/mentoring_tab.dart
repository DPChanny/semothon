import 'package:flutter/material.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/my_mentor_tab/my_mentor_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/recommended_mentor_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/recommended_room_tab.dart';
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
          const SizedBox(height: 16),
          // ✅ 탭 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: List.generate(tabLabels.length, (index) {
                final isSelected = _selectedTabIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTabSelected(index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.blue : Colors.black54,
                          ),
                          child: Text(tabLabels[index]),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 2,
                          color: isSelected ? const Color(0xFF008CFF) : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 8),

          // ✅ 콘텐츠 영역
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
