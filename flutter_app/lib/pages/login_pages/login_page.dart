import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_dto.dart';
import 'package:flutter_app/routes/input_page_routes.dart';
import 'package:flutter_app/routes/login_page_routes.dart';
import 'package:flutter_app/routes/main_page_routes.dart';
import 'package:flutter_app/url.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser;
      if (bool.parse(dotenv.env['WEB'] ?? 'false')) {
        googleUser =
            await GoogleSignIn(
              clientId:
                  "254852353422-kcl2cd2d287plmqrr2vdui80coh9koq3.apps.googleusercontent.com",
            ).signIn();
      } else {
        googleUser = await GoogleSignIn().signIn();
      }

      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String? idToken = await user.getIdToken();

        final response = await http.post(
          url('/api/users/login'),
          headers: {
            'Authorization': 'Bearer $idToken',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> jsonBody = jsonDecode(response.body);

          final userInfoJson = jsonBody['data']?['user']?['userInfo'];

          if (userInfoJson != null) {
            final user = UserDTO.fromJson(userInfoJson);
            if (user.introText != null) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                MainPageRouteNames.mainPage,
                (route) => false,
              );
            } else if (user.name != null) {
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
          } else {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('로그인 실패: parsing failure')));
          }
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('로그인 실패: server failure')));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('로그인 실패: firebase failure')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('로그인 실패: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 80),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, MainPageRouteNames.mainPage);
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
          ],
        ),
      ),
    );
  }
}
