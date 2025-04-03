import 'package:flutter/material.dart';
import 'package:flutter_app/routes/main_page_routes.dart';

class CreateRoomCompletePage extends StatelessWidget {
  const CreateRoomCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          // ✅ 전체를 수직/수평 가운데 정렬
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // ✅ 내용만큼만 차지해서 가운데 정렬됨
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFE6F0FA),
                  radius: 32,
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF008CFF),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "모든 준비가\n완료되었습니다.",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 80), // 버튼과 간격
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, MainPageRouteNames.mainPage);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008CFF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("확인", style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
