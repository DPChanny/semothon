import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Map<String, dynamic>> messages = [
    {
      'user': '천재',
      'text': 'goodgood',
      'time': DateTime(2025, 4, 2, 20, 40),
      'isMe': true,
    },
    {
      'system': true,
      'text': '🙌 비쿨한 로삐 님이 입장하였습니다',
      'time': DateTime(2025, 4, 3, 6, 39),
    },
    {
      'user': '나',
      'text': 'Baaad한 날이지만 나는 Good 해',
      'time': DateTime(2025, 4, 3, 6, 40),
      'isMe': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final room = ModalRoute.of(context)?.settings.arguments as Map<String, String>? ?? {
      'title': '채팅방',
    };

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Container(
          color: const Color(0xFFE5E5E5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                room['image']!,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                room['title'] ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '대화를 시작해 보세요!',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              room['title'] ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            const Text('4', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                if (msg['system'] == true) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      color: const Color(0xFFF7F9FF),
                      child: Column(
                        children: [
                          const Text('🙌', style: TextStyle(fontSize: 24)),
                          const SizedBox(height: 6),
                          Text(
                            msg['text'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Noto Sans KR',
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final DateTime time = msg['time'];
                final bool isMe = msg['isMe'];

                bool showDateSeparator = false;
                if (index == 0) {
                  showDateSeparator = true;
                } else {
                  final prevTime = messages[index - 1]['time'] as DateTime;
                  showDateSeparator = !isSameDay(prevTime, time);
                }

                final messageWidget = Row(
                  mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundImage: NetworkImage(room['image']!),
                        ),
                      ),
                    Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Text(
                            msg['user'],
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          constraints: const BoxConstraints(maxWidth: 280),
                          decoration: BoxDecoration(
                            color: isMe ? const Color(0xFF008CFF) : const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: Radius.circular(isMe ? 16 : 0),
                              bottomRight: Radius.circular(isMe ? 0 : 16),
                            ),
                          ),
                          child: Text(
                            msg['text'],
                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('a h:mm', 'ko').format(time),
                          style: const TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDateSeparator) buildDateSeparator(time),
                    messageWidget,
                  ],
                );
              },
            ),
          ),

          // 입력창
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE6E6E6))),
              color: Colors.white,
            ),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.add_circle_outline)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.insert_emoticon)),
                Expanded(
                  child: Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: '메시지 입력',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.trim().isEmpty) return;
                    setState(() {
                      messages.add({
                        'user': '나',
                        'text': _controller.text.trim(),
                        'time': DateTime.now(),
                        'isMe': true,
                      });
                      _controller.clear();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF008CFF),
                    minimumSize: const Size(48, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    '전송',
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDateSeparator(DateTime date) {
    final formatted =
        "${date.year}년 ${date.month}월 ${date.day}일 ${_getWeekday(date.weekday)}";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider(color: Color(0xFFD9D9D9), thickness: 0.6)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: SizedBox(
              height: 17,
              child: Center(
                child: Text(
                  formatted,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 10,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.17,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: Color(0xFFD9D9D9), thickness: 0.6)),
        ],
      ),
    );
  }

  String _getWeekday(int weekday) {
    const days = ['월', '화', '수', '목', '금', '토', '일'];
    return '${days[weekday - 1]}요일';
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}