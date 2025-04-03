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
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ({String message, bool success, UserInfoDto? user})? _user;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userResult.message)),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPageRouteNames.loginPage,
            (route) => false,
      );
      return;
    }

    if (userResult.user!.interests == null) {
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

    final mentors = await getUserList(sortBy: "SCORE", limit: 3);
    if(!mentors.success){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mentors.message)),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPageRouteNames.loginPage,
            (route) => false,
      );
      return;
    }

    final crawlings = await getCrawlingList();
    if(!crawlings.success){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(crawlings.message)),
      );
      Navigator.pushNamedAndRemoveUntil(
        context,
        LoginPageRouteNames.loginPage,
            (route) => false,
      );
      return;
    }

    setState(() {
      _user = userResult;
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

    final pageController = PageController(viewportFraction: 0.85);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          interestCard(context, _user!.user!, _user!.user!.interests!),
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
                            onTap: () {},
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
                        children: _mentors?.userInfos.map((m) => mentorItem(m)).toList() ?? [],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: const [
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
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: _crawlings.length,
                    itemBuilder: (context, index) {
                      return crawlingItem(context, _crawlings[index]);
                    },
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
