import 'package:flutter/material.dart';
import 'package:flutter_app/routes/mentoring_tab_routes.dart';

class BecomeMentorPage extends StatelessWidget {
  const BecomeMentorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 75,
              backgroundColor: Color(0xFFE0F3FF),
              child: ClipOval(
                child: Image.asset(
                  'assets/ok_man_icon.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "지금 바로 멘토가 되어 보세요",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "누구나 멘토가 될 수 있어요",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  MyMentorTabRouteNames.shortIntroInputPage,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              child: const Text(
                '나도 멘토 되기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.29,
                ),
              )
            ),
          ]

      ),
    );
  }
}
