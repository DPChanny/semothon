import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/dto/unread_message_count_dto.dart';
import 'package:flutter_app/services/queries/room_query.dart';
import 'package:flutter_app/widgets/chat_item.dart';
import 'package:flutter_app/widgets/empty_chat_card.dart';

class RoomChattingTab extends StatelessWidget {
  final List<ChatRoomInfoDto> roomInfos;
  final List<UnreadMessageCountDto> unreadInfos;

  const RoomChattingTab({
    super.key,
    required this.roomInfos,
    required this.unreadInfos,
  });

  @override
  Widget build(BuildContext context) {
    if (roomInfos.isEmpty) {
      return const EmptyChatCard(
        emoji: '💡',
        title: '멘토링을 통해\n다양한 정보를 얻어보세요',
        subtitle: '맞춤 추천 해드려요!',
        buttonText: '멘토링 참여하기',
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    result.success ? '채팅방을 나갔습니다' : '나가기 실패: ${result.message}',
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
