import 'package:flutter/material.dart';
import 'mentoring_room_tab.dart';
import 'activity_room_tab.dart';

class ChatMentoringPage extends StatefulWidget {
  const ChatMentoringPage({super.key});

  @override
  State<ChatMentoringPage> createState() => _ChatMentoringPageState();
}

class _ChatMentoringPageState extends State<ChatMentoringPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '채팅',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.29,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.person, color: Colors.grey), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings, color: Colors.grey), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF008CFF),
          labelColor: const Color(0xFF008CFF),
          unselectedLabelColor: const Color(0xFFB1B1B1),
          labelStyle: const TextStyle(
            fontSize: 15,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w700,
            letterSpacing: -0.26,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 15,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.26,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(text: '멘토링 방'),
            Tab(text: '활동 방'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MentoringRoomTab(),
          ActivityRoomTab(),
        ],
      ),
    );
  }
}
