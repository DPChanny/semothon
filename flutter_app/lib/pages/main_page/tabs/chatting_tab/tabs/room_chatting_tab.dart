import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/empty_chat_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/routes/chat_page_routes.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart'; // ChatRoomInfoDto가 정의된 파일 import

class RoomChattingTab extends StatelessWidget {
  final List<ChatRoomInfoDto> roomInfos;

  const RoomChattingTab({super.key, required this.roomInfos});

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

    return ListView.separated(
      itemCount: roomInfos.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final room = roomInfos[index];

        return Slidable(
          key: ValueKey(room.roomId),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (_) {
                  // 나가기 처리 등은 필요 시 콜백으로 받아서 전달 가능
                },
                backgroundColor: const Color(0xFFFF4D4D),
                foregroundColor: Colors.white,
                icon: Icons.exit_to_app,
                label: '나가기',
              ),
            ],
          ),
          child: ListTile(
            onTap: () {
              Navigator.pushNamed(
                context,
                ChatPageRouteNames.chattingPage,
                arguments: room,
              );
            },
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(room.profileImageUrl),
            ),
            title: Text(
              '${room.title}  💬 ${room.currentMemberCount}',
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                fontFamily: 'Noto Sans KR',
              ),
            ),
            subtitle: Text(
              room.lastMessage.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatTime(room.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(room.createdAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.year % 100}/${dt.month}/${dt.day.toString().padLeft(2, '0')}';

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }
}
