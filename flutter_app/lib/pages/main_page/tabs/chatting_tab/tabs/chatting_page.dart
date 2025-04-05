import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';
import 'package:flutter_app/dto/message_info_dto.dart';
import 'package:flutter_app/services/queries/chat_query.dart';
import 'package:flutter_app/websocket.dart';
import 'package:flutter_svg/svg.dart';
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
      backgroundColor: Colors.white,
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: NetworkImage(room.profileImageUrl),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      room.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 사진
              ListTile(
                leading: SvgPicture.asset('assets/image_icon.svg', width: 24, height: 24),
                title: const Text('사진'),
                onTap: () {},
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 파일, 수정
              ListTile(
                leading: SvgPicture.asset('assets/clip_icon.svg', width: 24, height: 24),
                title: const Text('파일'),
                onTap: () {},
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue, size: 24),
                title: const Text('채팅방 정보 수정'),
                onTap: () {},
              ),

              const Divider(),

              // 참여자
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text('참여자', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    Text('${room.currentMemberCount}', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (_, index) {
                  final members = [
                    {'name': '천재', 'role': '방장'},
                    {'name': '나', 'role': ''},
                    {'name': '날다디나는 코알라곰', 'role': ''},
                    {'name': '눈마른 User', 'role': ''},
                  ];
                  final m = members[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                      radius: 18,
                    ),
                    title: Row(
                      children: [
                        Text(m['name']!),
                        const SizedBox(width: 4),
                        if (m['role'] != '')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF008CFF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              m['role']!,
                              style: const TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          )
                      ],
                    ),
                  );
                },
              ),

              const Divider(height: 1, color: Color(0xFFD9D9D9)),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F6F8),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          contentPadding: const EdgeInsets.all(0),
                          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23.5)),
                          content: Container(
                            width: 335,
                            padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '정말 나가시겠어요?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 24,
                                    fontFamily: 'Noto Sans KR',
                                    fontWeight: FontWeight.w700,
                                    height: 1.42,
                                    letterSpacing: -0.41,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  '해당 버튼 선택 시, 채팅방 정보가 \n모두 삭제되며 복구되지 않습니다.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    fontFamily: 'Noto Sans KR',
                                    fontWeight: FontWeight.w400,
                                    height: 1.65,
                                    letterSpacing: -0.29,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // ✅ 버튼 세로 배치로 수정
                                ElevatedButton(
                                  onPressed: () {
                                    // 나가기 로직
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF008CFF),
                                    minimumSize: const Size.fromHeight(48),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text(
                                    '확인',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'Noto Sans KR',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.29,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    '취소',
                                    style: TextStyle(
                                      color: Color(0xFF999999),
                                      fontSize: 17,
                                      fontFamily: 'Noto Sans KR',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.29,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                    },
                    icon: const Icon(Icons.logout, color: Color(0xFF999999), size: 18),
                    label: const Text(
                      '채팅 나가기',
                      style: TextStyle(
                        color: Color(0xFF999999),
                        fontSize: 12,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.20,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        final isMe = msg.senderId == currentUser?.uid;
        final DateTime time = msg.createdAt;

        bool showDateSeparator =
            index == 0 || !isSameDay(messages[index - 1].createdAt, time);

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
          SvgPicture.asset('assets/clip_icon.svg', width: 24, height: 24),
          SvgPicture.asset('assets/image_icon.svg', width: 24, height: 24),
          Expanded(
            child: Container(
              height: 39,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F8),
                borderRadius: BorderRadius.circular(23.5),
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
