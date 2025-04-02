import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/dto/user_register_dto.dart';
import 'package:flutter_app/routes/input_page_routes.dart';
import 'package:flutter_app/routes/login_page_routes.dart';
import 'package:flutter_app/url.dart';
import 'package:http/http.dart' as http;


Future<bool> registerUser(String idToken) async {
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $idToken',
  };

  final body = jsonEncode(UserRegisterDTO.instance.toJson());

  final response = await http.patch(
    url('/api/users/profile'),
    headers: headers,
    body: body,
  );

  return (response.statusCode == 200);
}

class GenderInputPage extends StatefulWidget {
  const GenderInputPage({super.key});

  @override
  State<GenderInputPage> createState() => _GenderInputPageState();
}

class _GenderInputPageState extends State<GenderInputPage> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          '사용자 정보',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.29,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              '성별을 선택해 주세요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.41,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_buildGenderButton('남'), _buildGenderButton('여')],
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 335,
                height: 47,
                child: ElevatedButton(
                  onPressed: _selectedGender != null
                    ? () async {
                    void _showRegisterFailureDialog() {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text("등록 실패"),
                          content: Text("서버와의 통신 중 오류가 발생했습니다."),
                        ),
                      );
                    }
                    UserRegisterDTO.instance.gender =
                    _selectedGender == '남' ? 'MALE' : 'FEMALE';

                      final idToken = await FirebaseAuth.instance.currentUser?.getIdToken(true);

                      if (idToken == null) {
                      Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/login_page",
                      (route) => false,
                      );
                      _showRegisterFailureDialog();
                      return;
                      }

                      // 로딩 인디케이터 표시
                      showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => const Center(child: CircularProgressIndicator()),
                      );

                      final success = await registerUser(idToken);

                      Navigator.pop(context); // 로딩 다이얼로그 닫기

                      if (success) {
                        Navigator.pushNamed(
                            context,
                            InputPageRouteNames.registerCompletePage);
                      } else {
                        Navigator.pushNamedAndRemoveUntil(
                      context,
                      LoginPageRouteNames.loginPage,
                      (route) => false,
                      );
                      _showRegisterFailureDialog();
                      }
                    }
                    : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedGender != null
                            ? const Color(0xFF008CFF)
                            : const Color(0xFFE4E4E4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.50),
                    ),
                  ),
                  child: Text(
                    '완료',
                    style: TextStyle(
                      color:
                          _selectedGender != null
                              ? Colors.white
                              : const Color(0xFFB1B1B1),
                      fontSize: 17,
                      fontFamily: 'Noto Sans KR',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.29,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderButton(String gender) {
    final bool isSelected = _selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender;
        });
      },
      child: Container(
        width: 136,
        height: 39,
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFF008CFF) : const Color(0xFFE4E4E4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(23.5),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          gender,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 17,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.29,
          ),
        ),
      ),
    );
  }
}
