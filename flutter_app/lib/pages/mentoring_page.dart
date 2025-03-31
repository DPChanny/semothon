import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/widgets/bottom_navigation.dart';

import 'package:flutter_app/dto/user_dto.dart';
import 'package:flutter_app/services/fetch_mentors.dart';
import 'package:flutter_app/widgets/mentor_item.dart';

class MentoringPage extends StatefulWidget {
  const MentoringPage({super.key});

  @override
  State<MentoringPage> createState() => _MentoringPageState();
}

class _MentoringPageState extends State<MentoringPage> {
  int _selectedTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return const MentorListView(); // 추천 멘토
      case 1:
        return const RecommendedRoomListView(); // 추천 멘토방
      case 2:
        return const Center(child: Text('멘토 되기 페이지')); // 멘토 되기
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar("멘토링"),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '멘토 검색',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),

          // 탭
          TabBarSection(
            selectedIndex: _selectedTabIndex,
            onTabSelected: _onTabSelected,
          ),

          // 탭 콘텐츠
          Expanded(child: _buildTabContent()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        currentIndex: 2,
        onTap: (index) {
          // 하단 탭 네비 처리
        },
      ),
    );
  }
}


// 탭바 위젯 (추천 멘토 / 멘토방 / 멘토 되기)
class TabBarSection extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const TabBarSection({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    const labels = ['추천 멘토', '추천 멘토방', '멘토 되기'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(labels.length, (index) {
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: () => onTabSelected(index),
          child: Text(
            labels[index],
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        );
      }),
    );
  }
}

class MentorListView extends StatelessWidget {
  const MentorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserDTO>>(
      future: fetchMentors(10), // 🔹 백엔드에서 mentor list 가져옴
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('추천 멘토가 없습니다.'));
        }

        final mentors = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: mentors.length,
          itemBuilder: (context, index) {
            return mentorItem(mentors[index]);
          },
        );
      },
    );
  }
}

class RecommendedRoomListView extends StatelessWidget {
  const RecommendedRoomListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6, // 예시
      padding: const EdgeInsets.all(12),
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Text('0${index + 1}'),
            title: const Text('프론트 빡시기'),
            subtitle: const Text(
              '현업과 선배들이 이야기하는 코딩\n진로를 위한 여러가지 추천 활동들',
            ),
            trailing: const Text('3 / 10', style: TextStyle(color: Colors.grey)),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}
