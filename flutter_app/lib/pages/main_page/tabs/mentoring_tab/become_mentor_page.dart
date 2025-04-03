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
          const CircleAvatar(
            radius: 75,
            backgroundColor: Color(0xFFE0F3FF),
            child: Text("🙆‍♂️", style: TextStyle(fontSize: 90)),
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
                MentoringTabRouteNames.shortIntroInputPage,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // pill shape
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            ),
            child: const Text(
              "나도 멘토 되기",
              style: TextStyle(fontSize: 17),
              selectionColor: Color(0xFFFFFFFF),
            ), //텍스트 하얀색으로
          ),
        ],
      ),
    );
  }
}
