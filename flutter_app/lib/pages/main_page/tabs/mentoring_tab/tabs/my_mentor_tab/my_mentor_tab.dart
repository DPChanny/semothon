import 'package:flutter/material.dart';
import 'package:flutter_app/dto/get_user_response_dto.dart';
import 'package:flutter_app/pages/main_page/tabs/mentoring_tab/tabs/my_mentor_tab/pages/become_mentor_page.dart';
import 'package:flutter_app/pages/mentor_info_page.dart';
import 'package:flutter_app/services/queries/user_query.dart';

class MyMentorTab extends StatefulWidget {
  const MyMentorTab({super.key});

  @override
  State<MyMentorTab> createState() => _MyMentorTabState();
}

class _MyMentorTabState extends State<MyMentorTab> {
  late Future<GetUserResponseDto?> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = _loadUser();
  }

  Future<GetUserResponseDto?> _loadUser() async {
    final result = await getUser();
    if (!result.success || result.user == null) {
      // 로그 출력이나 에러 처리 가능
      return null;
    }
    return result.user!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetUserResponseDto?>(
      future: _futureUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("유저 정보를 불러오지 못했습니다."));
        }

        final user = snapshot.data!;
        return user.isHost()
            ? MentorInfoPage(userId: user.userInfo.userId)
            : const BecomeMentorPage();
      },
    );
  }
}
