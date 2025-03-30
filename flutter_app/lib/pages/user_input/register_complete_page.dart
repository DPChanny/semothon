import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/dto/user_dto.dart';

import '../../dto/user_register_dto.dart';

class RegisterCompletePage extends StatelessWidget {
  const RegisterCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // ✅ 텍스트 좌측 정렬
            children: [
              const SizedBox(height: 80), // ✅ 위로 올리기
              Center(
                child: SvgPicture.asset(
                  'assets/check_icon_line.svg', // ❗ 아이콘 경로 확인!
                  width: 78,
                  height: 78,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                '${UserRegisterDTO.instance.nickname} 님\n정보 입력이 완료되었습니다.',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.42,
                  letterSpacing: -0.41,
                  fontFamily: 'Noto Sans KR',
                ),
              ),
              const Spacer(),
              Center(
                child: const Text(
                  '맞춤 서비스를 위해\n키워드 선택을 시작하겠습니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    height: 1.53,
                    letterSpacing: -0.26,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: SizedBox(
                  width: 335,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home_page',
                            (Route<dynamic> route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008CFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23.5),
                      ),
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
