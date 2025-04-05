import 'package:flutter/material.dart';
import 'package:flutter_app/pages/mentor_info_page.dart';
import 'package:flutter_app/services/queries/user_query.dart';
import 'package:flutter_app/dto/user_info_dto.dart';

class MyInterestPage extends StatefulWidget {
  const MyInterestPage({super.key});

  @override
  State<MyInterestPage> createState() => _MyInterestPageState();
}

class _MyInterestPageState extends State<MyInterestPage> {
  UserInfoDto? _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final result = await getUser();
    if (result.success && result.user != null) {
      setState(() {
        _userInfo = result.user!.userInfo;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final nickname = _userInfo?.nickname ?? "사용자";
    final summary = _userInfo?.introText ?? "분석된 관심사 요약이 없습니다.";
    final keywords = _userInfo?.interests ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("나의 관심분야"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Noto Sans KR',
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: nickname,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const TextSpan(text: '님의 관심분야는?'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'AI가 분석한 나의 관심 분야는 다음과 같아요.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontFamily: 'Noto Sans KR',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F8FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  summary,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '키워드',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Noto Sans KR',
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: keywords
                    .map((tag) => KeywordChip(text: tag))
                    .toList(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    // 수정 페이지 이동
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "수정하기",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Noto Sans KR',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
