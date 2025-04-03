import 'package:flutter/material.dart';

class MyMentorTab extends StatelessWidget {
  const MyMentorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 프로필
          Center(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150', // 실제 이미지 URL로 변경 가능
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "날라다니는 코딩뱀",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                const Text(
                  '"컴공과 4학년으로 프론트쪽으로 취업 예정입니다."',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // 관심 태그
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    for (final tag in ['개발', 'UX', '프론트', '프로젝트', '코딩', '그래픽 디자인', 'UI'])
                      Chip(
                        label: Text(tag, style: const TextStyle(fontSize: 12)),
                        backgroundColor: const Color(0xFFE7F0FF),
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 멘토링 리스트
          _MentorRoomItem(index: 1),
          const SizedBox(height: 12),
          _MentorRoomItem(index: 2),

          const SizedBox(height: 32),

          // 버튼
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008CFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text("멘토방 추가하기"),
            ),
          ),
        ],
      ),
    );
  }
}

class _MentorRoomItem extends StatelessWidget {
  final int index;

  const _MentorRoomItem({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("0$index 멘토방", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          const Text(
            "프론트 뿌시기",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          const Text(
            "컴공과 4학년이 이야기하는 프론트 진로를 위한 여러 가지 추천 활동들...",
            style: TextStyle(fontSize: 13),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "수정하기",
              style: TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
