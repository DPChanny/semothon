import 'package:flutter/material.dart';
import 'package:flutter_app/routes/interest_page_routes.dart';
import 'package:flutter_app/routes/login_page_routes.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InputCompletePage extends StatelessWidget {
  const InputCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData ||
            !snapshot.data!.success ||
            snapshot.data!.user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(snapshot.data!.message)));
            Navigator.pushNamedAndRemoveUntil(
              context,
              LoginPageRouteNames.loginPage,
              (route) => false,
            );
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final name = snapshot.data!.user!.userInfo.nickname;

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
                      '$name 님\n정보 입력이 완료되었습니다.',
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
                    const Center(
                      child: Text(
                        '맞춤 서비스를 위해\n키워드 선택을 시작하겠습니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
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
                              InterestPageRouteNames
                                  .interestCategorySelectionPage,
                              (route) => false,
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
      },
    );
  }
}
