import 'package:flutter/material.dart';
import 'package:flutter_app/dto/get_user_response_dto.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/routes/mentoring_tab_routes.dart';
import 'package:flutter_app/services/queries/user_query.dart';

class MentorInfoPage extends StatelessWidget {
  const MentorInfoPage({super.key});

  Future<UserInfoDto?> _fetchUserInfo() async {
    final result = await getUser();
    if (result.success && result.user != null) {
      return result.user!.userInfo;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserInfoDto?>(
      future: _fetchUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("유저 정보를 불러올 수 없습니다."));
        }

        final userInfo = snapshot.data!;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(userInfo.profileImageUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userInfo.nickname ?? '닉네임 없음',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '"${userInfo.shortIntro ?? "한 줄 소개가 없습니다."}"',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: userInfo.interests.map((tag) {
                        return Chip(
                          label: Text(tag, style: const TextStyle(fontSize: 12)),
                          backgroundColor: const Color(0xFFE7F0FF),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const _MentorRoomItem(index: 1),
              const SizedBox(height: 12),
              const _MentorRoomItem(index: 2),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, MentoringTabRouteNames.createRoomPage);
                  },
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
      },
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
