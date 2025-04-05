import 'package:flutter/material.dart';
import 'package:flutter_app/dto/get_user_list_response_dto.dart';
import 'package:flutter_app/routes/login_page_routes.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/widgets/mentor_item.dart';

class RecommendedMentorTab extends StatelessWidget {
  const RecommendedMentorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<
      ({bool success, String message, GetUserListResponseDto? userList})
    >(
      future: getUserList(sortBy: "SCORE"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(snapshot.data!.message)));
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginPageRouteNames.loginPage,
            (route) => false,
          );
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.userList!.userInfos.isEmpty) {
          return const Center(child: Text('추천 멘토가 없습니다.'));
        }
        else {
          final mentors = snapshot.data!.userList!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: mentors.userInfos.length,
            itemBuilder: (context, index) {
              return MentorItem(mentor: mentors.userInfos[index]);
            },
          );
        }
      },
    );
  }
}
