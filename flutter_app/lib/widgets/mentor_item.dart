import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/pages/mentor_info_page.dart';

class MentorItem extends StatelessWidget {
  final UserInfoDto mentor;

  const MentorItem({super.key, required this.mentor});

  void _handleClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: const Text("멘토링"),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          body: MentorInfoPage(userId: mentor.userId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleClick(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
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
          ],
        ),
      ),
    );
  }
}
