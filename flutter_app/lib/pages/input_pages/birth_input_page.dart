import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_update_dto.dart';
import 'package:flutter_app/routes/input_page_routes.dart';
import 'package:intl/intl.dart';

class BirthInputPage extends StatefulWidget {
  const BirthInputPage({super.key});

  @override
  State<BirthInputPage> createState() => _BirthInputPageState();
}

class _BirthInputPageState extends State<BirthInputPage> {
  DateTime? selectedDate;

  String get formattedDate {
    if (selectedDate == null) return 'YYYY-MM-DD';
    return DateFormat('yyyy-MM-dd').format(selectedDate!);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
      locale: const Locale('ko', 'KR'), // 한글화
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submit() {
    if (selectedDate != null) {
      UserUpdateDTO.instance.birthdate = selectedDate;
      Navigator.pushNamed(context, InputPageRouteNames.genderInputPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isButtonEnabled = selectedDate != null;

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
              '생년월일을 입력해 주세요.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.41,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              '생년월일',
              style: TextStyle(
                color: Color(0xFFB1B1B1),
                fontFamily: 'Noto Sans KR',
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
            GestureDetector(
              onTap: _pickDate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 12,
                ),
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFF008CFF))),
                ),
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.29,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: SizedBox(
                width: 335,
                height: 47,
                child: ElevatedButton(
                  onPressed: isButtonEnabled ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isButtonEnabled
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
                          isButtonEnabled
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
