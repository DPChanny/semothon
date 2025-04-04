import 'package:flutter/material.dart';

class SearchScreenPage extends StatefulWidget {
  const SearchScreenPage({super.key});

  @override
  State<SearchScreenPage> createState() => _SearchScreenPageState();
}

class _SearchScreenPageState extends State<SearchScreenPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
            // ✅ 양옆 여백 추가
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                autofocus: true,
                controller: _controller,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  hintText: '나의 멘토링방 제목으로 검색하기',
                  hintStyle: TextStyle(
                    color: Color(0xFFB1B1B1),
                    fontSize: 15,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.26,
                  ),
                  prefixIcon: Icon(Icons.search, color: Color(0xFFB1B1B1)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8), // ✅ 오른쪽 간격 정리
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  '취소',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: 'Noto Sans KR',
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ 본문에도 전체 패딩 적용
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: const Center(
          child: Text('검색 결과 또는 힌트를 보여주는 공간', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}
