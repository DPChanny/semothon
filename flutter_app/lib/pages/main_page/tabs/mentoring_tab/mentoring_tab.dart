import 'package:flutter/material.dart';
import 'package:flutter_app/dto/host_user_info_dto.dart';
import 'package:flutter_app/dto/room_info_dto.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/my_mentor_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/recommended_mentor_tab.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/recommended_room_tab.dart';
import 'package:flutter_app/widgets/custom_tab_bar.dart';

class MentoringTab extends StatefulWidget {
  const MentoringTab({super.key});

  @override
  State<MentoringTab> createState() => _MentoringTabState();
}

class _MentoringTabState extends State<MentoringTab> {
  int _selectedTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  static const tabLabels = ['추천 멘토', '추천 멘토방', 'My 멘토'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: '멘토 검색',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFE4E4E4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),
          CustomTabBar(
            labels: tabLabels,
            selectedIndex: _selectedTabIndex,
            onTabSelected: _onTabSelected,
          ),
          Expanded(
            child: IndexedStack(
              index: _selectedTabIndex,
              children: const [
                RecommendedMentorTab(),
                RecommendedRoomTab(),
                MyMentorTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendedRoomDetailModal extends StatelessWidget {
  final RoomInfoDto room;
  final HostUserInfoDto hostUser;

  const RecommendedRoomDetailModal({
    super.key,
    required this.room,
    required this.hostUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Text(
            room.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  room.description,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${room.capacity} / 10',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(hostUser.profileImageUrl),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('방장', style: TextStyle(color: Colors.grey)),
                  Text(
                    hostUser.nickname,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size.fromHeight(45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("입장하기"),
          ),
        ],
      ),
    );
  }
}
