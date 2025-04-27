import 'package:flutter/material.dart';
import 'package:flutter_app/routes/input_page_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginCompletePage extends StatelessWidget {
  const LoginCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/check_icon.svg', width: 60, height: 60),
              const SizedBox(height: 20),
              const Text(
                '회원가입이 완료되었습니다.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Noto Sans KR',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '당신의 진로를 UNUS와 함께 시작해보세요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontFamily: 'Noto Sans KR'),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 335,
                height: 47,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF008CFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      InputPageRouteNames.nameInputPage,
                      (route) => false,
                    );
                  },
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w700,
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
}
