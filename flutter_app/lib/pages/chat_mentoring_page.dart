import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_register_dto.dart';

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
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        actions: const [
          Icon(Icons.settings, color: Colors.black),
          SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF008CFF),
          labelColor: Color(0xFF008CFF),
          unselectedLabelColor: Colors.black,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
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

class MentoringRoomTab extends StatelessWidget {
  const MentoringRoomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCenteredCard(
      emoji: _buildEmojiCircle('💡'),
      title: '멘토링을 통해\n다양한 정보를 얻어보세요',
      subtitle: '맞춤 추천 해드려요!',
      buttonText: '멘토링 참여하기',
      onPressed: () {},
    );
  }
}

class ActivityRoomTab extends StatelessWidget {
  const ActivityRoomTab({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildCenteredCard(
      emoji: _buildEmojiCircle('👊'),
      title: '다른 사람과 함께\n공모전을 도전해보세요',
      subtitle: '으싸으싸 화이팅!',
      buttonText: '공모전 알아보기',
      onPressed: () {},
    );
  }
}

Widget _buildEmojiCircle(String emoji) {
  return Container(
    width: 141,
    height: 141,
    decoration: const BoxDecoration(
      color: Color(0xFFD8EDFF),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 64),
      ),
    ),
  );
}

Widget _buildCenteredCard({
  required Widget emoji,
  required String title,
  required String subtitle,
  required String buttonText,
  required VoidCallback onPressed,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          emoji,
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Noto Sans KR',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFamily: 'Noto Sans KR',
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
            height: 40,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF008CFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontFamily: 'Noto Sans KR',
                ),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
