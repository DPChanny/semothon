import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_update_dto.dart';
import 'package:flutter_app/routes/input_page_routes.dart';
import 'package:flutter_app/routes/login_page_routes.dart';
import 'package:flutter_app/services/queries/user_query.dart';

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
                  onPressed:
                      _selectedGender != null
                          ? () async {
                            UserUpdateDTO.instance.gender =
                                _selectedGender == '남' ? 'MALE' : 'FEMALE';

                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder:
                                  (context) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                            );

                            final result = await updateUser();

                            if (result.success) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                InputPageRouteNames.inputCompletePage,
                                (route) => false,
                              );
                            } else {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                LoginPageRouteNames.loginPage,
                                (route) => false,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result.message)),
                              );
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
