import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class MentoringRoomTab extends StatefulWidget {
  const MentoringRoomTab({super.key});

  @override
  State<MentoringRoomTab> createState() => _MentoringRoomTabState();
}

class _MentoringRoomTabState extends State<MentoringRoomTab> {
  final TextEditingController _searchController = TextEditingController();
  late List<Map<String, String>> chatRooms;

  @override
  void initState() {
    super.initState();
    chatRooms = [
      {
        'title': '프로토 뿌시기',
        'message': '우와 그거는 어떻게 하는 거예요?',
        'time': '5:13 PM',
        'date': '25/3/20',
        'image': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
      },
      {
        'title': '위둔 뿌시기',
        'message': 'File: 웹, 이거슨, 언제 끝나나...',
        'time': '4:21 PM',
        'date': '25/3/20',
        'image': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (chatRooms.isNotEmpty)
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
          child: chatRooms.isEmpty
              ? const _EmptyChatCard()
              : ListView.separated(
            itemCount: chatRooms.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final room = chatRooms[index];
              return Slidable(
                key: ValueKey(room['title']),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        setState(() {
                          chatRooms.removeAt(index);
                        });
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
                      '/chat_detail_page',
                      arguments: room,
                    );
                  },
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(room['image']!),
                  ),
                  title: Text(
                    '${room['title']}  💬 3',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontFamily: 'Noto Sans KR',
                    ),
                  ),
                  subtitle: Text(
                    room['message']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        room['time']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        room['date']!,
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
  }
}

class _EmptyChatCard extends StatelessWidget {
  const _EmptyChatCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 141,
              height: 141,
              decoration: const BoxDecoration(
                color: Color(0xFFD8EDFF),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('💡', style: TextStyle(fontSize: 64)),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '멘토링을 통해\n다양한 정보를 얻어보세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w500,
                height: 1.42,
                letterSpacing: -0.41,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '맞춤 추천 해드려요!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Noto Sans KR',
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 160,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
                child: const Text(
                  '멘토링 참여하기',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.29,
                    color: Colors.white,
                    fontFamily: 'Noto Sans KR',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
