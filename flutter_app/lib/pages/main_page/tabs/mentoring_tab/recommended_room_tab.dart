import 'package:flutter/material.dart';
import 'package:flutter_app/dto/get_room_list_response_dto.dart';
import 'package:flutter_app/dto/host_user_info_dto.dart';
import 'package:flutter_app/dto/room_info_dto.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/mentoring_tab.dart';
import 'package:flutter_app/services/queries/room_query.dart';
import 'package:flutter_app/widgets/recommended_chatroom.dart';

class RecommendedRoomTab extends StatelessWidget {
  const RecommendedRoomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<
      ({bool success, String message, GetRoomListResponseDto? roomList})
    >(
      future: getRoomList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData ||
            !snapshot.data!.success ||
            snapshot.data!.roomList == null) {
          return Center(
            child: Text(
              '방 목록을 불러오지 못했어요: ${snapshot.data?.message ?? '알 수 없는 오류'}',
            ),
          );
        }

        final rooms = snapshot.data!.roomList!.roomInfos;
        final hostInfos = snapshot.data!.roomList!.hostInfos;

        return ListView.builder(
          itemCount: rooms.length,
          itemBuilder: (context, index) {
            final room = rooms[index];
            final hostUser = hostInfos[index];
            return GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  isScrollControlled: true,
                  builder:
                      (context) => RecommendedRoomDetailModal(
                        room: room,
                        hostUser: hostUser,
                      ),
                );
              },
              child: RecommendedChatRoom(room: room, index: index),
            );
          },
        );
      },
    );
  }
}

class RecommendedRoomDetailModal extends StatelessWidget {
  final RoomInfoDto room;
  final HostUserInfoDto hostUser;

  const RecommendedRoomDetailModal({
    super.key,
    required this.room,
    required this.hostUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Text(
            room.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  room.description,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${room.capacity} / 10',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(hostUser.profileImageUrl),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('방장', style: TextStyle(color: Colors.grey)),
                  Text(
                    hostUser.nickname,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("입장하기"),
          ),
        ],
      ),
    );
  }
}
