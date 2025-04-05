import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/dto/unread_message_count_dto.dart';
import 'package:flutter_app/services/queries/room_query.dart';
import 'package:flutter_app/widgets/chat_item.dart';

class RoomChattingTab extends StatelessWidget {
  final void Function(int) onTabChange;

  final List<ChatRoomInfoDto> roomInfos;
  final List<UnreadMessageCountDto> unreadInfos;


  const RoomChattingTab({
    super.key,
    required this.roomInfos,
    required this.unreadInfos,
    required this.onTabChange
  });

  @override
  Widget build(BuildContext context) {
    if (roomInfos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/electric_light_bulb_icon.png', // 🔹 이미지 경로
                width: 83,
                height: 109,
              ),
              const SizedBox(height: 16),
              const Text(
                '멘토링을 통해\n다양한 정보를 얻어보세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Noto Sans KR',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '맞춤 추천 해드려요!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontFamily: 'Noto Sans KR',
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  onTabChange(2);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  '멘토링 참여하기',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto Sans KR',
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: roomInfos.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final room = roomInfos[index];
        final unread = unreadInfos.firstWhere(
              (item) => item.chatRoomId == room.chatRoomId,
        );

        return ChatItem(
          room: room,
          unreadCount: unread.unreadCount,
          onLeave: () async {
            final result = await leaveRoom(room.roomId!);

            if (context.mounted) {
              if (!result.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result.message),
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
