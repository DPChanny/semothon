import 'package:flutter/material.dart';
import 'package:flutter_app/services/queries/room_query.dart';
import 'package:flutter_app/widgets/empty_chat_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_app/routes/chat_page_routes.dart';
import 'package:flutter_app/dto/get_room_list_response_dto.dart';

class RoomChattingTab extends StatefulWidget {
  const RoomChattingTab({super.key});

  @override
  State<RoomChattingTab> createState() => _RoomChattingTabState();
}

class _RoomChattingTabState extends State<RoomChattingTab> {
  late Future<({bool success, String message, GetRoomListResponseDto? roomList})> _roomListFuture;

  @override
  void initState() {
    super.initState();
    _roomListFuture = getRoomList(joinedOnly: true, sortBy: "SCORE");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _roomListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || !(snapshot.data?.success ?? false)) {
          return const Center(child: Text('채팅방 정보를 불러올 수 없습니다.'));
        }

        final roomList = snapshot.data!.roomList!;
        final roomInfos = roomList.roomInfos;
        final hostInfos = roomList.hostInfos;

        if (roomInfos.isEmpty) {
          return const EmptyChatCard(
            emoji: '💡',
            title: '멘토링을 통해\n다양한 정보를 얻어보세요',
            subtitle: '맞춤 추천 해드려요!',
            buttonText: '멘토링 참여하기',);
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/search_screen_page');
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        '멘토 검색',
                        style: TextStyle(
                          color: Color(0xFFB1B1B1),
                          fontSize: 15,
                          fontFamily: 'Noto Sans KR',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: roomInfos.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final room = roomInfos[index];
                  final host = hostInfos[index];

                  return Slidable(
                    key: ValueKey(room.roomId),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            // 나가기 처리 추가 가능
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
                          arguments: room, // 필요 시 host도 함께 전달
                        );
                      },
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(host.profileImageUrl),
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
                        room.description,
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
              ),
            ),
          ],
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