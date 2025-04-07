import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/dto/unread_message_count_dto.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/crawling_chatting_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/room_chatting_tab.dart';
import 'package:flutter_app/services/queries/chat_query.dart';
import 'package:flutter_app/services/queries/user_query.dart';

class ChattingTab extends StatefulWidget {
  final void Function(int) onTabChange;

  const ChattingTab({super.key, required this.onTabChange});

  @override
  State<ChattingTab> createState() => _ChattingTabState();
}

class _ChattingTabState extends State<ChattingTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<void> _loadFuture;

  List<ChatRoomInfoDto> roomChattingRooms = [];
  List<ChatRoomInfoDto> crawlingChattingRooms = [];
  List<UnreadMessageCountDto> unreadCounts = [];

  final labels = ['멘토링 방', '활동 방'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: labels.length, vsync: this);
    _loadFuture = loadData();
  }

  Future<void> loadData() async {
    final user = await getUser();
    final unread = await getUnreadMessageCount();

    final rooms = user.chatRooms;
    final crawls = <ChatRoomInfoDto>[];
    final mentos = <ChatRoomInfoDto>[];

    for (var room in rooms) {
      if (room.type == 'CRAWLING') {
        crawls.add(room);
      } else if (room.type == 'ROOM') {
        mentos.add(room);
      }
    }

    setState(() {
      roomChattingRooms = mentos;
      crawlingChattingRooms = crawls;
      unreadCounts = unread.unreadCounts;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('유저 정보를 불러올 수 없습니다.'));
          }

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: List.generate(labels.length, (index) {
                    final isSelected = _tabController.index == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _tabController.animateTo(index),
                        child: AnimatedBuilder(
                          animation: _tabController.animation!,
                          builder: (_, __) {
                            final selected = _tabController.index == index;
                            return Container(
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color:
                                    selected
                                        ? const Color(0xFF008CFF)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                labels[index],
                                style: TextStyle(
                                  color:
                                      selected
                                          ? Colors.white
                                          : const Color(0xFFB1B1B1),
                                  fontSize: 15,
                                  fontWeight:
                                      selected
                                          ? FontWeight.w700
                                          : FontWeight.w400,
                                  fontFamily: 'Noto Sans KR',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    RoomChattingTab(
                      roomInfos: roomChattingRooms,
                      unreadInfos: unreadCounts,
                      onTabChange: widget.onTabChange,
                    ),
                    CrawlingChattingTab(
                      roomInfos: crawlingChattingRooms,
                      unreadInfos: unreadCounts,
                      onTabChange: widget.onTabChange,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
