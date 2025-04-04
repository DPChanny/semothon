import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/pages/mentor_info_page.dart';

class MentorItem extends StatefulWidget {
  final UserInfoDto mentor;

  const MentorItem({super.key, required this.mentor});

  @override
  State<MentorItem> createState() => _MentorItemState();
}

class _MentorItemState extends State<MentorItem> {
  bool _isClicked = false;

  void _handleClick() async {
    setState(() => _isClicked = true);

    await Future.delayed(const Duration(milliseconds: 150));

    setState(() => _isClicked = false);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(
                title: const Text("멘토링"),
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              body: MentorInfoPage(userId: widget.mentor.userId),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mentor = widget.mentor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(mentor.profileImageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mentor.nickname ?? "",
                  style: const TextStyle(
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.29,
                    fontSize: 17,
                  ),
                ),
                Text(
                  "${mentor.department ?? ""} ${mentor.studentId ?? ""}학번",
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 12,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.20,
                  ),
                ),
                Text(
                  mentor.shortIntro ?? "",
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 12,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.20,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _handleClick,
            style: ElevatedButton.styleFrom(
              backgroundColor: _isClicked ? Colors.blue : Colors.white70,
              foregroundColor: _isClicked ? Colors.white : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              minimumSize: const Size(75, 10),
              elevation: 0,
            ),
            child: const Text('알아보기'),
          ),
        ],
      ),
    );
  }
}
