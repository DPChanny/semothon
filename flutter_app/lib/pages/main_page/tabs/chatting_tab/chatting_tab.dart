
import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/dto/get_unread_message_count_response_dto.dart';
import 'package:flutter_app/dto/get_user_response_dto.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/crawling_chatting_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/room_chatting_tab.dart';
import 'package:flutter_app/services/queries/chat_query.dart';
import 'package:flutter_app/services/queries/user_query.dart';

class ChattingTab extends StatefulWidget {
  const ChattingTab({super.key});

  @override
  State<ChattingTab> createState() => _ChattingTabState();
}

class _ChattingTabState extends State<ChattingTab> {
  int _selectedTabIndex = 0;

  late Future<({bool success, String message, GetUserResponseDto? user})> _userFuture;
  late Future<({bool success, String message, GetUnreadMessageCountResponseDto? room})> _unreadFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = getUser();
    _unreadFuture = getUnreadMessageCount();
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  final labels = ['멘토링 방', '활동 방'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: Future.wait([_userFuture, _unreadFuture]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData ||
              !(snapshot.data![0] as ({bool success, String message, GetUserResponseDto? user})).success ||
              !(snapshot.data![1] as ({bool success, String message, GetUnreadMessageCountResponseDto? room})).success) {
            return const Center(child: Text('유저 정보를 불러올 수 없습니다.'));
          }

          final userData = snapshot.data![0] as ({bool success, String message, GetUserResponseDto? user});
          final unreadData = snapshot.data![1] as ({bool success, String message, GetUnreadMessageCountResponseDto? room});

          final crawlingChattingRooms = <ChatRoomInfoDto>[];
          final roomChattingRooms = <ChatRoomInfoDto>[];

          for (var room in userData.user!.chatRooms) {
            if (room.type == 'CRAWLING') {
              crawlingChattingRooms.add(room);
            } else if (room.type == 'ROOM') {
              roomChattingRooms.add(room);
            }
          }

          return Column(
            children: [
              // Custom styled tab bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: List.generate(labels.length, (index) {
                    final isSelected = _selectedTabIndex == index;

                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onTabSelected(index),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF008CFF) : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            labels[index],
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFFB1B1B1),
                              fontSize: 15,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                              fontFamily: 'Noto Sans KR',
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              if (_selectedTabIndex == 0)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/search_screen_page');
                    },
                    child: Container(
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6F8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.grey),
                          SizedBox(width: 8),
                          Text(
                            '나의 멘토링방 제목으로 검색하기',
                            style: TextStyle(
                              color: const Color(0xFF999999),
                              fontSize: 14,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.24,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: IndexedStack(
                  index: _selectedTabIndex,
                  children: [
                    RoomChattingTab(
                      roomInfos: roomChattingRooms,
                      unreadInfos: unreadData.room!.unreadCounts,
                    ),
                    CrawlingChattingTab(
                      roomInfos: crawlingChattingRooms,
                      unreadInfos: unreadData.room!.unreadCounts,
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
