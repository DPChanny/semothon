import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_update_interest_dto.dart';
import 'package:flutter_app/routes/interest_page_routes.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/dto/user_update_dto.dart';
import 'package:flutter_app/routes/login_page_routes.dart';

class IntroDetailPage extends StatefulWidget {
  const IntroDetailPage({super.key});

  @override
  State<IntroDetailPage> createState() => _IntroDetailPageState();
}

class _IntroDetailPageState extends State<IntroDetailPage> {
  final TextEditingController _controller = TextEditingController();


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

          if (!snapshot.hasData || !snapshot.data!.success || snapshot.data!.user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snapshot.data!.message)));
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

          final nickname = snapshot.data!.user!.userInfo.nickname;

          return Scaffold(
            appBar: AppBar(
              leading: const BackButton(color: Colors.black),
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                '선호도 선택',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Stack(
                      children: [
                        Container(height: 4, width: double.infinity, color: const Color(0xFFE4E4E4)),
                        Container(height: 4, width: MediaQuery.of(context).size.width * 0.99, color: const Color(0xFF008CFF)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'AI 가 $nickname 님의 관심사를 \n다음과 같이 분석했어요.',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Noto Sans KR',
                        fontWeight: FontWeight.w700,
                        height: 1.42,
                        letterSpacing: -0.41,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F8FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        UserUpdateInterestIntroDTO.instance.generatedIntroText ?? "",
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Image.asset('assets/light_white_icon.png', width: 20, height: 27),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            '더 자세한 분석을 원하시면 \n밑에 내용을 추가해 주세요.',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: 'Noto Sans KR',
                              fontWeight: FontWeight.w500,
                              height: 1.59,
                              letterSpacing: -0.29,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 90,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFB1B1B1)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _controller,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '예시) 저는 공간 디자인 중에서도 컨셉적인 연출 위주로 하고 싶어요.',
                          hintStyle: TextStyle(
                            color: Color(0xFFB1B1B1),
                            fontSize: 15,
                            fontFamily: 'Noto Sans KR',
                            fontWeight: FontWeight.w400,
                            height: 1.60,
                            letterSpacing: -0.26,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16), // 버튼 위 여백
                    SizedBox(
                      width: double.infinity,
                      height: 48, // 높이는 필요시 유지
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(child: CircularProgressIndicator()),
                          );

                          UserUpdateInterestIntroDTO.instance.intro = _controller.text;

                          final result = await updateUserIntro();

                          Navigator.pop(context);

                          if (result.success) {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              InterestPageRouteNames.introDetailCompletePage,
                                  (route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result.message)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF008CFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          '다음',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }}