import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/routes/chat_page_routes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChatItem extends StatelessWidget {
  final ChatRoomInfoDto room;
  final int unreadCount;
  final VoidCallback? onLeave;

  const ChatItem({
    super.key,
    required this.room,
    this.unreadCount = 0,
    this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(room.roomId),
      endActionPane:
          onLeave != null
              ? ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => onLeave!(),
                    backgroundColor: const Color(0xFFFF4D4D),
                    foregroundColor: Colors.white,
                    icon: Icons.exit_to_app,
                    label: '나가기',
                  ),
                ],
              )
              : null,
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
          '${room.title}  👥 ${room.currentMemberCount}${unreadCount > 0 ? " 🔴 $unreadCount" : ""}',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            fontFamily: 'Noto Sans KR',
          ),
        ),
        subtitle: Text(
          room.lastMessage?.message ?? room.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(room.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              _formatDate(room.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
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
