import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/dto/unread_message_count_dto.dart';
import 'package:flutter_app/services/queries/chat_query.dart';
import 'package:flutter_app/widgets/chat_item.dart';
import 'package:flutter_app/widgets/search_widget.dart';

class SearchChattingPage extends StatefulWidget {
  const SearchChattingPage({super.key});

  @override
  State<SearchChattingPage> createState() => _SearchChattingPageState();
}

class _SearchChattingPageState extends State<SearchChattingPage> {
  final TextEditingController _controller = TextEditingController();
  List<ChatRoomInfoDto> _roomResults = [];
  List<ChatRoomInfoDto> _crawlingResults = [];
  List<UnreadMessageCountDto> _unreadResults = [];
  bool _isLoading = false;
  String _error = "";

  Future<void> _search() async {
    final rawInput = _controller.text.trim();
    if (rawInput.isEmpty) return;

    setState(() {
      _isLoading = true;
      _roomResults = [];
      _crawlingResults = [];
      _error = "";
    });

    final result = await getChatList(titleOrDescriptionKeyword: rawInput.split(' '));
    final result2 = await getUnreadMessageCount();

    if (result.success && result.roomList != null) {
      final rooms = <ChatRoomInfoDto>[];
      final crawlings = <ChatRoomInfoDto>[];

      for (var room in result.roomList!.chatRoomList) {
        if (room.type == 'ROOM') {
          rooms.add(room);
        } else if (room.type == 'CRAWLING') {
          crawlings.add(room);
        }
      }

      setState(() {
        _roomResults = rooms;
        _crawlingResults = crawlings;
        _unreadResults = result2.room?.unreadCounts ?? [];
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.message;
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _controller.clear();
      _roomResults = [];
      _crawlingResults = [];
      _error = "";
    });
  }

  int _getUnreadCount(int roomId) {
    return _unreadResults
        .firstWhere(
          (item) => item.chatRoomId == roomId,
      orElse: () => UnreadMessageCountDto(chatRoomId: roomId, unreadCount: 0),
    )
        .unreadCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchWidget(
                controller: _controller,
                onClear: _clearSearch,
                onSearch: _search,
              ),
              const SizedBox(height: 16),
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_error.isNotEmpty)
                Center(child: Text('오류: $_error'))
              else if (_roomResults.isEmpty && _crawlingResults.isEmpty)
                  const Center(child: Text('검색 결과가 없습니다'))
                else ...[
                    if (_roomResults.isNotEmpty) ...[
                      const Text(
                        '멘토링 방',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _roomResults.length,
                        itemBuilder: (context, index) {
                          final room = _roomResults[index];
                          return ChatItem(
                            room: room,
                            unreadCount: _getUnreadCount(room.chatRoomId),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                    if (_crawlingResults.isNotEmpty) ...[
                      const Text(
                        '활동 방',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _crawlingResults.length,
                        itemBuilder: (context, index) {
                          final room = _crawlingResults[index];
                          return ChatItem(
                            room: room,
                            unreadCount: _getUnreadCount(room.chatRoomId),
                          );
                        },
                      ),
                    ]
                  ],
            ],
          ),
        ),
      ),
    );
  }
}
