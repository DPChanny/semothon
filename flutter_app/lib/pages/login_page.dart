import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/pages/user_input/name_input_page.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),

            // ✅ 로고 누르면 정보 입력 페이지로 이동
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NameInputPage(),
                  ),
                );
              },
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    image: const DecorationImage(
                      image: AssetImage('assets/logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 60),

            const Text(
              '회원가입',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Noto Sans KR',
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              '학교 계정으로 회원가입 해주세요.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Noto Sans KR',
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 36),

            // ✅ Google 버튼 (팝업 띄움)
            Container(
              width: 263,
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFB1B1B1),
                  ),
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      showGeneralDialog(
                        context: context,
                        barrierDismissible: false,
                        barrierLabel: '회원가입 완료',
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Scaffold(
                            backgroundColor: Colors.white,
                            body: SafeArea(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/check_icon.svg',
                                      width: 60,
                                      height: 60,
                                    ),
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
                                      '당신의 진로를 Pathagora와 함께 시작해보세요!',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Noto Sans KR',
                                      ),
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
                                          Navigator.pushNamed(context, '/home');
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
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Image.asset(
                      'assets/google_logo.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Google 계정으로 가입',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Noto Sans KR',
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
