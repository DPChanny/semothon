import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chatting/chat_room_info_dto.dart';
import 'package:flutter_app/dto/chatting/unread_message_count_dto.dart';
import 'package:flutter_app/services/queries/crawling_query.dart';
import 'package:flutter_app/widgets/chat_item.dart';

class CrawlingChatRoomTab extends StatelessWidget {
  final void Function(int) onTabChange;

  final List<ChatRoomInfoDTO> chatRoomInfos;
  final List<UnreadMessageCountDTO> unreadInfos;

  const CrawlingChatRoomTab({
    super.key,
    required this.chatRoomInfos,
    required this.unreadInfos,
    required this.onTabChange,
  });

  void _handleLeaveCrawlingChatRoom(BuildContext context, ChatRoomInfoDTO room) async {
    try {
      await leaveCrawlingChatRoom(room.crawlingId!, room.chatRoomId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('채팅방을 나갔습니다')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('나가기 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (chatRoomInfos.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 141,
                    height: 141,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F4FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Image.asset('assets/fist.png', width: 96, height: 96),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '다른 사람과 함께\n공모전을 도전해보세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Noto Sans KR',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '으싸으싸 화이팅!',
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
                  onTabChange(3);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  '공모전 알아보기',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto Sans KR',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: chatRoomInfos.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final room = chatRoomInfos[index];
        final unread = unreadInfos.firstWhere(
          (item) => item.chatRoomId == room.chatRoomId,
        );
        return ChatRoomItem(
          chatRoom: room,
          unreadCount: unread.unreadCount,
          onLeave:  () => _handleLeaveCrawlingChatRoom(context, room)
        );
      },
    );
  }
}
