import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      endActionPane: onLeave != null
          ? ActionPane(
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            onPressed: (_) => onLeave!(),
            backgroundColor: const Color(0xFF008CFF),
            child: Container(
              width: 40, // 🔹 너비 직접 지정
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.exit_to_app, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    '나가기',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
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
        title: Row(
          children: [
            Text(
              room.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.26,
              ),
            ),
            const SizedBox(width: 10),
            SvgPicture.asset(
              'assets/widget_icon/mentoring_icon.svg', // 👤 SVG 아이콘
              width: 14,
              height: 14,
            ),
            const SizedBox(width: 2),
            Text(
              '${room.currentMemberCount}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        subtitle: Text(
          room.lastMessage?.message ?? room.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: const Color(0xFF999999),
            fontSize: 12,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w400,
            height: 1.25,
            letterSpacing: -0.20,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(room.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF008CFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: const BoxConstraints(minWidth: 24, minHeight: 20),
                child: Text(
                  unreadCount >  999 ? '999+' : '$unreadCount',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
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

  String _formatDate(DateTime dt) =>
      '${dt.year % 100}/${dt.month}/${dt.day.toString().padLeft(2, '0')}';

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
  }
}
