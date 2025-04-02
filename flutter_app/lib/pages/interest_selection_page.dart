import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/dto/user_register_dto.dart';

class InterestSelectionPage extends StatefulWidget {
  const InterestSelectionPage({super.key});

  @override
  State<InterestSelectionPage> createState() => _InterestSelectionPageState();
}

class _InterestSelectionPageState extends State<InterestSelectionPage> {
  String? selectedLabel;

  final List<Map<String, String>> interests = [
    {'icon': 'assets/interest_icon/book_icon.svg', 'label': '인문계열'},
    {'icon': 'assets/interest_icon/social_icon.svg', 'label': '사회계열'},
    {'icon': 'assets/interest_icon/edu_icon.svg', 'label': '교육계열'},
    {'icon': 'assets/interest_icon/engineering_icon.svg', 'label': '공학 계열'},
    {'icon': 'assets/interest_icon/science_icon.svg', 'label': '자연 계열'},
    {'icon': 'assets/interest_icon/medical_icon.svg', 'label': '의학 계열'},
    {'icon': 'assets/interest_icon/art_icon.svg', 'label': '예체능 계열'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  '선호도 선택',
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Stack(
                children: [
                  Container(height: 4, width: double.infinity, color: Color(0xFFE4E4E4)),
                  Container(height: 4, width: MediaQuery.of(context).size.width * 0.33, color: Color(0xFF008CFF)),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                '현재 관심있는 분야는 \n어디인가요?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w700,
                  height: 1.42,
                  letterSpacing: -0.41,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 12,
                  children: interests.map((item) {
                    return _buildInterestItem(item['icon']!, item['label']!);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 335,
                  height: 47,
                  child: ElevatedButton(
                    onPressed: selectedLabel != null
                        ? () {
                      UserRegisterDTO.instance.interest = selectedLabel!;
                      Navigator.pushNamed(context, "/detail_selection_page");
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedLabel != null ? const Color(0xFF008CFF) : const Color(0xFFE4E4E4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23.5),
                      ),
                    ),
                    child: Text(
                      '다음',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: selectedLabel != null ? Colors.white : const Color(0xFFB1B1B1),
                        fontFamily: 'Noto Sans KR',
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
    );
  }

  Widget _buildInterestItem(String iconPath, String label) {
    final bool isSelected = selectedLabel == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLabel = label;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? const Color(0xFF008CFF) : Colors.white,
              border: Border.all(color: const Color(0xFF008CFF), width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SvgPicture.asset(
                iconPath,
                colorFilter: ColorFilter.mode(
                  isSelected ? Colors.white : const Color(0xFF008CFF),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.26,
            ),
          ),
        ],
      ),
    );
  }
}
