import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_dto.dart';

Widget mentorItem(UserDTO mentor) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(mentor.profileImageUrl ??
              'https://semothon.s3.ap-northeast-2.amazonaws.com/profile-images/default.png'),
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
                "${mentor.department ?? ""} ${("${mentor.studentId}학번") ?? "학번"}",
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white70,
            foregroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            minimumSize: const Size(75, 10), // 버튼 최소 크기
          ),
          child: const Text('알아보기'),
        )

      ],
    ),
  );
}
