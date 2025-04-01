import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_dto.dart';

class MentorButton extends StatefulWidget {
  const MentorButton({super.key});

  @override
  State<MentorButton> createState() => _MentorButtonState();
}

class _MentorButtonState extends State<MentorButton> {
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isClicked = true; // 버튼 클릭 시 상태 변경
        });
      },
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
    );
  }
}


Widget mentorItem(UserDTO mentor) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
            mentor.profileImageUrl ??
                'https://semothon.s3.ap-northeast-2.amazonaws.com/profile-images/default.png',
          ),
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
                "${mentor.department ?? ""} ${("${mentor.studentId}학번")}",
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
        MentorButton(),
      ],
    ),
  );
}
