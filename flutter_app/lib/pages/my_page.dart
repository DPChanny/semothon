import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/dto/chat_room_info_dto.dart';


Future<bool> isCurrentUserHost() async {
  final result = await getUser();
  if (!result.success || result.user == null) return false;
  return result.user!.isHost();
}

Widget BuildBecomeMentorSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xffe8f0fe),
            child: Text("🙆‍♂️", style: TextStyle(fontSize: 30)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("지금 바로 멘토가 되어 보세요",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("누구나 멘토가 될 수 있어요",
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: 멘토 등록 로직
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 20)),
                  child: const Text("나도 멘토 되기"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget BuildMentorSection(List<ChatRoomInfoDto> chatRooms) {
  final mentorIntro = chatRooms.isNotEmpty ? chatRooms.first.description : '멘토 소개글이 없습니다.';

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text("My 멘토", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
          ],
        ),
        const SizedBox(height: 8),

        const Text("멘토 소개글", style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold)),
        Text("“$mentorIntro”", style: TextStyle(fontSize: 12,),),

        const SizedBox(height: 12),
        const Text("멘토방", style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        ...chatRooms.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final room = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                Text(index.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text(room.title, style: TextStyle(fontSize: 12),),
                const Spacer(),
                const Icon(Icons.group, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text("${room.currentMemberCount}/${room.capacity}",
                    style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}

class MyPageHeader extends StatefulWidget {
  final UserInfoDto user;
  final List<ChatRoomInfoDto> chatRooms;

  const MyPageHeader({Key? key, required this.user, required this.chatRooms}) : super(key: key);

  @override
  State<MyPageHeader> createState() => _MyPageHeaderState();
}

class _MyPageHeaderState extends State<MyPageHeader> {
  bool? _isHost;

  @override
  void initState() {
    super.initState();
    _checkHostStatus();
  }

  Future<void> _checkHostStatus() async {
    final hostStatus = await isCurrentUserHost();
    setState(() {
      _isHost = hostStatus;
    });
  }

  String _formatBirthdate(DateTime? birthdate) {
    if (birthdate == null) return '';
    return DateFormat('yyyyMMdd').format(birthdate);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // 상단 영역 (생략)

          const SizedBox(height: 12),

          // 닉네임
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.user.nickname ?? '닉네임 없음',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),

          const SizedBox(height: 8),

          // 이름, 성별, 생년월일, 전공, 학번
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget.user.name ?? ''} (${widget.user.gender ?? ''})',
                      style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                  Text(_formatBirthdate(widget.user.birthdate),
                      style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.user.department ?? '',
                      style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                  Text(widget.user.studentId ?? '',
                      style: TextStyle(fontSize: 10, color: Colors.grey[700])),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // 관심 분야
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: const [
                Text('나의 관심분야', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.user.interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  interest,
                  style: const TextStyle(fontSize: 10 ,color: Colors.white),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // ✅ 멘토 or 멘토아님
          if (_isHost == null)
            const CircularProgressIndicator()
          else if (_isHost!)
            BuildMentorSection(widget.chatRooms)
          else
            BuildBecomeMentorSection(),
        ],
      ),
    );
  }
}
