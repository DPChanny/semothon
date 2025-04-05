import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/login_pages/login_page.dart'; // 👈 MainPage 경로 맞게 수정해줘!

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // 2초 후 MainPage로 이동
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // 내용 크기만큼 정중앙 정렬
          children: [
            SizedBox(
              width: 184.95,
              height: 176.44,
              child: Image.asset(
                'assets/intro_1.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 12), // 두 이미지 사이 간격
            SizedBox(
              width: 147,
              height: 78,
              child: Image.asset(
                'assets/intro_2.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
