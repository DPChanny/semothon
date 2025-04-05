import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/routes/input_page_routes.dart';
import 'package:flutter_app/routes/login_page_routes.dart';
import 'package:flutter_app/routes/main_page_routes.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/websocket.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> signInWithGoogle(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final GoogleSignInAccount? googleUser = await getGoogleSignIn().signIn();
    if (googleUser == null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("google failure")));
      return;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    final result = await loginUser();
    if (!result.success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
      return;
    }

    if (result.user!.introText != null) {
      await StompService.instance.connect();
      Navigator.pushNamedAndRemoveUntil(
        context,
        MainPageRouteNames.mainPage,
        (route) => false,
      );
    } else if (result.user!.name != null) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        InputPageRouteNames.inputCompletePage,
        (route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPageRouteNames.loginCompletePage,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,       // 세로 가운데 정렬
          crossAxisAlignment: CrossAxisAlignment.center,     // 가로 가운데 정렬
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/logo.svg', // 👈 로고 경로 (예시, 네 파일 이름에 맞게)
                width: 150, // ✅ 너가 원하는 2배 크기
                fit: BoxFit.contain, // ✅ 비율 유지
              )
            ),

            const SizedBox(height: 30),

            const Text(
              '회원가입',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                fontFamily: 'Noto Sans KR',
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Google 버튼 (팝업 띄움)
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(19),
                onTap: () async => signInWithGoogle(context),
                child: Ink(
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
                      Image.asset(
                        'assets/google_logo.png',
                        width: 24,
                        height: 24,
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
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
