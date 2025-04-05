import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_update_dto.dart';
import 'package:flutter_app/routes/input_page_routes.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NameInputPage extends StatefulWidget {
  const NameInputPage({super.key});

  @override
  State<NameInputPage> createState() => _NameInputPageState();
}

class _NameInputPageState extends State<NameInputPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isButtonEnabled = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
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
              '이름을 입력해 주세요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.41,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _controller,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w400,
                letterSpacing: -0.29,
              ),
              decoration: InputDecoration(
                labelText: '이름',
                labelStyle: const TextStyle(
                  color: Color(0xFFB1B1B1),
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.20,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    _controller.clear();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      'assets/X_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF008CFF)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF008CFF)),
                ),
              ),
              cursorColor: const Color(0xFF008CFF),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 335,
                height: 47,
                child: ElevatedButton(
                  onPressed:
                      _isButtonEnabled
                          ? () {
                            UserUpdateDTO.instance.name = _controller.text;
                            Navigator.pushNamed(
                              context,
                              InputPageRouteNames.nicknameInputPage,
                            );
                          }
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isButtonEnabled
                            ? const Color(0xFF008CFF)
                            : const Color(0xFFE4E4E4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(23.50),
                    ),
                  ),
                  child: Text(
                    '다음',
                    style: TextStyle(
                      color:
                          _isButtonEnabled
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
}
