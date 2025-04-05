import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/dto/crawling_info_dto.dart';
import 'package:flutter_app/dto/get_user_list_response_dto.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/routes/interest_page_routes.dart';
import 'package:flutter_app/routes/login_page_routes.dart';
import 'package:flutter_app/services/queries/crawling_query.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/widgets/crawling_item.dart';
import 'package:flutter_app/widgets/interest_card.dart';
import 'package:flutter_app/widgets/mentor_item.dart';

class HomeTab extends StatefulWidget {
  final void Function(int) onTabChange;

  const HomeTab({super.key, required this.onTabChange});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  UserInfoDto? _userInfo;
  GetUserListResponseDto? _mentors;
  List<CrawlingInfoDto> _crawlings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userResult = await getUser();

    if (!userResult.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(userResult.message)));
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPageRouteNames.loginPage,
        (route) => false,
      );
      return;
    }

    if (userResult.user!.userInfo.interests.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("관심사를 먼저 설정해주세요.")));
      Navigator.pushNamedAndRemoveUntil(
        context,
        InterestPageRouteNames.interestCategorySelectionPage,
        (route) => false,
      );
      return;
    }

    final mentors = await getUserList(sortBy: "SCORE");
    if (!mentors.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(mentors.message)));
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPageRouteNames.loginPage,
        (route) => false,
      );
      return;
    }

    final crawlings = await getCrawlingList(sortBy: "SCORE");
    if (!crawlings.success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(crawlings.message)));
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPageRouteNames.loginPage,
        (route) => false,
      );
      return;
    }

    setState(() {
      _userInfo = userResult.user!.userInfo;
      _mentors = mentors.userList;
      _crawlings = crawlings.crawlingList!.crawlingList;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          interestCard(context, _userInfo!, _userInfo!.interests),
          Transform.translate(
            offset: const Offset(0, -90),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 0),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              '추천 멘토 List',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onTabChange(2);
                            },
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children:
                            _mentors?.userInfos.sublist(0, min(_mentors!.userInfos.length, 3))
                                .map((m) => MentorItem(mentor: m))
                                .toList() ??
                            [],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '추천 활동',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '관심사 분석을 통해 세모님의 맞춤형 활동을 추천합니다.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          widget.onTabChange(3);
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    height: 170.44, // 🟡 아이템 크기와 정확히 맞춤
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      controller: PageController(
                        viewportFraction: 107.4 / MediaQuery.of(context).size.width, // 🔹 아이템 너비 / 화면 너비
                      ),
                      padEnds: false, // ✅ 맨 앞 빈 공간 제거
                      itemCount: min(_crawlings.length, 5),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8), // 카드 사이 여백
                          child: crawlingItem(context, _crawlings[index]),
                        );
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
