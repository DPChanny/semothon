import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_update_dto.dart';
import 'package:flutter_app/routes/mentoring_tab_routes.dart';
import 'package:flutter_app/services/queries/user_query.dart';

class ShortIntroInputPage extends StatefulWidget {
  const ShortIntroInputPage({super.key});

  @override
  State<ShortIntroInputPage> createState() => _ShortIntroInputPageState();
}

class _ShortIntroInputPageState extends State<ShortIntroInputPage> {
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
                suffixIcon:
                    _controller.text.isNotEmpty
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
                onPressed:
                    _isButtonEnabled
                        ? () async {
                          UserUpdateDTO.instance = UserUpdateDTO(
                            shortIntro: _controller.text,
                          );

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
                              MyMentorTabRouteNames.shortIntroInputCompletePage,
                              (routes) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result.message)),
                            );
                          }
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
