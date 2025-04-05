import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dto/get_room_list_response_dto.dart';
import 'package:flutter_app/dto/get_user_response_dto.dart';
import 'package:flutter_app/dto/host_user_info_dto.dart';
import 'package:flutter_app/dto/room_info_dto.dart';
import 'package:flutter_app/routes/mentoring_tab_routes.dart';
import 'package:flutter_app/services/queries/room_query.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/widgets/room_pop_up.dart';

class KeywordChip extends StatelessWidget {
  final String text;

  const KeywordChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF008CFF), // 🔵 파란 배경
        border: Border.all(color: const Color(0xFF008CFF)), // 🔵 파란 테두리
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white, // ⚪ 흰 글자
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class MentorInfoPage extends StatelessWidget {
  final String userId;

  const MentorInfoPage({super.key, required this.userId});

  Future<(String uid, GetUserResponseDto? user, String message)>
  _fetchUserAndRooms() async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

    final result = await getOtherUser(userId);
    if (!result.success || result.user == null) {
      return (currentUid, null, result.message);
    }

    return (currentUid, result.user!, result.message);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(String, GetUserResponseDto?, String)>(
      future: _fetchUserAndRooms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.$2 == null) {
          return const Center(child: Text("유저 정보를 불러올 수 없습니다."));
        }

        final currentUid = snapshot.data!.$1;
        final user = snapshot.data!.$2!;
        final userInfo = user.userInfo;
        final isMine = userInfo.userId == currentUid;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 👤 멘토 정보
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"${userInfo.shortIntro ?? "한 줄 소개가 없습니다."}"',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children:
                            userInfo.interests.map((tag) {
                              return KeywordChip(text: tag);
                            }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // 📚 멘토링 방 목록
                FutureBuilder<
                  ({
                    bool success,
                    String message,
                    GetRoomListResponseDto? roomList,
                  })
                >(
                  future: getRoomList(hostUserId: userInfo.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData ||
                        !snapshot.data!.success ||
                        snapshot.data!.roomList == null) {
                      return const Center(child: Text("멘토링 방 목록을 불러올 수 없습니다."));
                    }

                    final rooms = snapshot.data!.roomList!.roomInfos;
                    final hosts = snapshot.data!.roomList!.hostInfos;

                    if (rooms.isEmpty) {
                      return const Center(child: Text("개설한 멘토링 방이 없습니다."));
                    }

                    return Column(
                      children: List.generate(rooms.length, (index) {
                        final room = rooms[index];
                        final host = hosts[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _MentorRoomItem(
                            index: index + 1,
                            room: room,
                            hostUser: host,
                            isMine: isMine,
                          ),
                        );
                      }),
                    );
                  },
                ),

                const SizedBox(height: 32),

                // ➕ 멘토방 추가 버튼 (내 정보일 때만)
                if (isMine)
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          MyMentorTabRouteNames.createRoomPage,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF008CFF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text("멘토방 추가하기"),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MentorRoomItem extends StatelessWidget {
  final int index;
  final RoomInfoDto room;
  final HostUserInfoDto hostUser;
  final bool isMine;

  const _MentorRoomItem({
    required this.index,
    required this.room,
    required this.hostUser,
    required this.isMine,
  });

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
          Text(
            room.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(room.description, style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: GestureDetector(
              onTap:
                  isMine
                      ? null
                      : () {
                        showModalBottomSheet(
                          context: context,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          isScrollControlled: true,
                          builder:
                              (context) =>
                                  RoomPopUp(room: room, hostUser: hostUser),
                        );
                      },
              child: Text(
                isMine ? "수정하기" : "알아보기",
                style: TextStyle(
                  fontSize: 12,
                  color: isMine ? Colors.blue : Colors.grey[700],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
