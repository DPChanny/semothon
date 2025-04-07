import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/dto/crawling/crawling_info_dto.dart';
import 'package:flutter_app/dto/user/user_info_dto.dart';
import 'package:flutter_app/dto/wrapper/user/get_user_list_response_dto.dart';
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

  bool _isMentorLoading = true;
  bool _isCrawlingLoading = true;

  late final PageController _crawlingPageController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenWidth = MediaQuery
          .of(context)
          .size
          .width;
      _crawlingPageController = PageController(
        viewportFraction: 107.4 / screenWidth,
      );
    });

    _loadData();
  }

  @override
  void dispose() {
    _crawlingPageController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final user = await getUser();
      if (!mounted) return;

      if (user.userInfo.interests.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("관심사를 먼저 설정해주세요.")),
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          InterestPageRouteNames.interestCategorySelectionPage,
              (route) => false,
        );
        return;
      }

      setState(() {
        _userInfo = user.userInfo;
      });

      getUserList(sortBy: "SCORE").then((mentorList) {
        if (!mounted) return;
        setState(() {
          _mentors = mentorList;
          _isMentorLoading = false;
        });
      });

      getCrawlingList(sortBy: "SCORE").then((crawlingList) {
        if (!mounted) return;
        setState(() {
          _crawlings = crawlingList.crawlingList;
          _isCrawlingLoading = false;
        });
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPageRouteNames.loginPage,
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          interestCard(context, _userInfo),
          Transform.translate(
            offset: const Offset(0, -90),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
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
                            onTap: () => widget.onTabChange(2),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _isMentorLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Column(
                        children: _mentors?.userInfos
                            .sublist(0, min(_mentors!.userInfos.length, 3))
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
                          children: const [
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
                        onTap: () => widget.onTabChange(3),
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
                    height: 170.44,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: _isCrawlingLoading
                        ? const Center(child: CircularProgressIndicator())
                        : PageView.builder(
                      controller: _crawlingPageController,
                      padEnds: false,
                      itemCount: min(_crawlings.length, 5),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
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
