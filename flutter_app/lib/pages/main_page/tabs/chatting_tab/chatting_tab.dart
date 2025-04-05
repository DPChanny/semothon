import 'package:flutter/material.dart';
import 'package:flutter_app/dto/get_user_response_dto.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/crawling_chatting_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/chatting_tab/tabs/room_chatting_tab.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/widgets/custom_tab_bar.dart';

class ChattingTab extends StatefulWidget {
  const ChattingTab({super.key});

  @override
  State<ChattingTab> createState() => _ChattingTabState();
}

class _ChattingTabState extends State<ChattingTab> {
  int _selectedTabIndex = 0;

  late Future<({bool success, String message, GetUserResponseDto? user})> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = getUser();
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
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || !(snapshot.data?.success ?? false)) {
            return const Center(child: Text('유저 정보를 불러올 수 없습니다.'));
          }

          final user = snapshot.data!.user!;

          return Column(
            children: [
              CustomTabBar(
                labels: labels,
                selectedIndex: _selectedTabIndex,
                onTabSelected: _onTabSelected,
              ),
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
                child: IndexedStack(
                  index: _selectedTabIndex,
                  children: [
                    RoomChattingTab(),
                    CrawlingChattingTab(),
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
