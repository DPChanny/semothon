import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/dto/unread_message_count_dto.dart';
import 'package:flutter_app/services/queries/room_query.dart';
import 'package:flutter_app/widgets/chat_item.dart';
import 'package:flutter_app/widgets/empty_chat_card.dart';

class CrawlingChattingTab extends StatelessWidget {
  final List<ChatRoomInfoDto> roomInfos;
  final List<UnreadMessageCountDto> unreadInfos;

  const CrawlingChattingTab({
    super.key,
    required this.roomInfos,
    required this.unreadInfos,
  });

  @override
  Widget build(BuildContext context) {
    if (roomInfos.isEmpty) {
      return const EmptyChatCard(
        emoji: '👊',
        title: '다른 사람과 함께\n공모전을 도전해보세요',
        subtitle: '으싸으싸 화이팅!',
        buttonText: '공모전 알아보기',
      );
    }

    return ListView.separated(
      itemCount: roomInfos.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final room = roomInfos[index];
        final unread = unreadInfos.firstWhere(
          (item) => item.chatRoomId == room.chatRoomId,
          orElse:
              () => UnreadMessageCountDto(
                chatRoomId: room.chatRoomId,
                unreadCount: 0,
              ),
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
