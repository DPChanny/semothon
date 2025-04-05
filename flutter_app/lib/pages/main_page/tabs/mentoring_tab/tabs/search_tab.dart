import 'package:flutter/material.dart';
import 'package:flutter_app/dto/get_room_list_response_dto.dart';
import 'package:flutter_app/dto/room_info_dto.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/services/queries/room_query.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/widgets/mentor_item.dart';
import 'package:flutter_app/widgets/room_item.dart'; // ✅ 너가 만든 위젯

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  List<RoomInfoDto> _roomResult = [];
  List<UserInfoDto> _userResult = [];
  bool _isLoading = false;
  String _error = "";

  Future<void> _search() async {
    final rawInput = _controller.text;
    if (rawInput.trim().isEmpty) return;

    final keywords = rawInput.split(' ').map((e) => e.trim()).toList();

    setState(() {
      _isLoading = true;
      _roomResult = [];
      _userResult = [];
      _error = "";
    });

    final roomResult = await getRoomList(titleOrDescriptionKeyword: keywords);
    final userResult = await getUserList(keyword: keywords.join(','));

    setState(() {
      _isLoading = false;
      if (roomResult.success && roomResult.roomList != null) {
        _roomResult = roomResult.roomList!.roomInfos;
      } else {
        _error = roomResult.message;
      }
      if (userResult.success && userResult.userList != null) {
        _userResult = userResult.userList!.userInfos;
      } else {
        _error = userResult.message;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 20, left: 16),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                autofocus: true,
                controller: _controller,
                onSubmitted: (_) => _search(),
                decoration: InputDecoration(
                  hintText: '나의 멘토링방 제목으로 검색하기',
                  hintStyle: const TextStyle(
                    color: Color(0xFFB1B1B1),
                    fontSize: 15,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.26,
                  ),
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Color(0xFFB1B1B1)),
                    onPressed: _search,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
              ? Center(child: Text('오류 발생: $_error'))
              : (_roomResult.isEmpty && _userResult.isEmpty)
              ? const Center(child: Text('검색 결과가 없습니다'))
              : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_roomResult.isNotEmpty) ...[
                  const Text(
                    '멘토링방',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _roomResult.length,
                    itemBuilder: (context, index) {
                      return RoomItem(
                        room: _roomResult[index],
                        index: index,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
                if (_userResult.isNotEmpty) ...[
                  const Text(
                    '멘토',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _userResult.length,
                    itemBuilder: (context, index) {
                      return MentorItem(
                        mentor: _userResult[index],
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        )

    );
  }
}
