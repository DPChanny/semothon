import 'package:flutter/material.dart';

// 다음 페이지로 이동할 위젯 import (같은 파일에 있어도 됨)
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/mentor_profile_complete.dart';

class MentorInfoInputPage extends StatefulWidget {
  const MentorInfoInputPage({super.key});

  @override
  State<MentorInfoInputPage> createState() => _MentorInfoInputPageState();
}

class _MentorInfoInputPageState extends State<MentorInfoInputPage> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  void _onTextChanged() {
    setState(() {
      _isButtonEnabled = _controller.text.trim().isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "멘토 정보 입력",
          style: TextStyle(
            fontSize: 17,
            fontFamily: 'Noto Sans KR',
            fontWeight: FontWeight.w400,
            letterSpacing: -0.29,
          ),
        ),
        leading: BackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "멘토로서 자신을\n한 줄로 소개해주세요",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "소개글",
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _controller.clear(),
                      )
                    : null,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MentorProfileCompletePage(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isButtonEnabled ? Colors.blue : Colors.grey.shade300,
                  foregroundColor:
                      _isButtonEnabled ? Colors.white : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("다음"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
