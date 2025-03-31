import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';

class MentoringPage extends StatelessWidget {
  const MentoringPage({super.key});

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
          const TabBarSection(),

          // 멘토 리스트
          Expanded(child: MentorListView()),
        ],
      ),
    );
  }
}

// 탭바 위젯 (추천 멘토 / 멘토방 / 멘토 되기)
class TabBarSection extends StatelessWidget {
  const TabBarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('추천 멘토', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        Text('추천 멘토방', style: TextStyle(color: Colors.grey)),
        Text('멘토 되기', style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// 멘토 리스트 뷰
class MentorListView extends StatelessWidget {
  const MentorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/mentor.jpg'), // 이미지 경로는 적절히 변경
          ),
          title: const Text('날라다니는 코딩맨'),
          subtitle: const Text('컴퓨터공학과 4학년\n프론트쪽으로 취업 예정'),
          trailing: const Text(
            '알아보기 >',
            style: TextStyle(color: Colors.blue),
          ),
          isThreeLine: true,
        );
      },
    );
  }
}
