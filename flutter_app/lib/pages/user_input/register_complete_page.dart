import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/dto/user_register_dto.dart';

class RegisterCompletePage extends StatelessWidget {
  const RegisterCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                SvgPicture.asset(
                  'assets/check_icon_line.svg',
                  width: 78,
                  height: 78,
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
      ),
    );
  }
}
