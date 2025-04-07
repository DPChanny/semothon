import 'package:flutter/material.dart';
import 'package:flutter_app/dto/user/user_info_dto.dart';
import 'package:flutter_app/routes/my_page_routes.dart';
import 'package:flutter_app/widgets/Interest_chip.dart';

Widget interestCard(
    BuildContext context,
    UserInfoDto? user,
    ) {
  if (user == null) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF008CFF),
      padding: const EdgeInsets.fromLTRB(45, 25, 45, 100),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  return Container(
    width: double.infinity,
    color: const Color(0xFF008CFF),
    padding: const EdgeInsets.fromLTRB(45, 25, 45, 100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '나의 관심분야는?',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '나의 현재 관심사를 확인하고\n수정해 보세요.',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 50),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/75'), // fallback
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
            SizedBox(
              width: MediaQuery.of(context).size.width - 150,
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: user.interests
                    .map((interest) => InterestChip(text: interest))
                    .toList(),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      MyPageRouteNames.myInterestPage,
                    );
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