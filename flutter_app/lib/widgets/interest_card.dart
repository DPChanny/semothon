import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/routes/my_page_routes.dart';
import 'package:flutter_app/widgets/keyword_chip.dart';

Widget interestCard(
  BuildContext context,
  UserInfoDto user,
  List<String> keywords,
) {
  return Container(
    width: double.infinity,
    color: const Color(0xFF008CFF),
    padding: const EdgeInsets.fromLTRB(45, 25, 45, 100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 상단 텍스트와 프로필
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 텍스트
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '나의 관심분야는?',
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '나의 현재 관심사를 확인하고\n수정해 보세요.',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 50),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.profileImageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // ✅ 키워드 Wrap (고정된 너비)
            SizedBox(
              width: MediaQuery.of(context).size.width - 150,
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children:
                    keywords
                        .map((keyword) => KeywordChip(text: keyword))
                        .toList(),
              ),
            ),
            // ✅ 아이콘을 오른쪽 끝으로 보내기
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, MyPageRouteNames.myInterestPage);
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
