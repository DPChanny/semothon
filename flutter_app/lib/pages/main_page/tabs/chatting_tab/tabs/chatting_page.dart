import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/dto/message_info_dto.dart';
import 'package:flutter_app/services/queries/chat_query.dart';
import 'package:flutter_app/websocket.dart';
import 'package:intl/intl.dart';

class ChattingPage extends StatefulWidget {
  const ChattingPage({super.key});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<MessageInfoDto> messages = [];

  late ChatRoomInfoDto room;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final result = await getChatMessage(room.chatRoomId);
      if (result.success && result.room != null) {
        setState(() {
          messages.addAll(result.room!.chatMessages);
        });
      }

      StompService.instance.subscribe('/sub/chat/${room.chatRoomId}', (frame) {
        final data = jsonDecode(frame.body!);
        final message = MessageInfoDto.fromJson(data);

        setState(() {
          messages.add(message);
        });
      });
    });
  }

  @override
  void dispose() {
    StompService.instance.unsubscribe('/sub/chat/${room.chatRoomId}');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    room = ModalRoute.of(context)?.settings.arguments as ChatRoomInfoDto;

    return Scaffold(
      key: _scaffoldKey,
      endDrawer: buildDrawer(),
      appBar: buildAppBar(),
      body: Column(
        children: [
          Expanded(child: buildMessageList()),
          buildInputBar(),
        ],
      ),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
        color: const Color(0xFFE5E5E5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(room.profileImageUrl, width: 96, height: 96),
            const SizedBox(height: 16),
            Text(room.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('대화를 시작해 보세요!', style: TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(room.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black)),
          const SizedBox(width: 4),
          Text('${room.currentMemberCount}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
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
    );
  }

  Widget buildMessageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];

        final bool isMe = msg.senderId == currentUser?.uid;
        final DateTime time = msg.createdAt;

        bool showDateSeparator = index == 0 ||
            !isSameDay(messages[index - 1].createdAt, time);

        final messageWidget = Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(msg.senderProfileImageUrl),
                ),
              ),
            Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Text(msg.senderNickname, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
                    msg.message,
                    style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 14),
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
    );
  }

  Widget buildInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE6E6E6))),
        color: Colors.white,
      ),
      child: Row(
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.insert_emoticon)),
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
            onPressed: sendMessage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF008CFF),
              minimumSize: const Size(48, 36),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: const Text('전송', style: TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final text = _controller.text.trim();

    final msg = {
      'chatRoomId': room.chatRoomId,
      'message': text,
      'imageUrl': null,
    };

    StompService.instance.send(
      '/pub/chat/message',
      jsonEncode(msg),
    );

    _controller.clear();
  }

  Widget buildDateSeparator(DateTime date) {
    final formatted = "${date.year}년 ${date.month}월 ${date.day}일 ${_getWeekday(date.weekday)}";

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
            child: Text(
              formatted,
              style: const TextStyle(
                color: Color(0xFF999999),
                fontSize: 10,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.17,
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
