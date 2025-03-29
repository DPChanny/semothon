import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 📦 모델 클래스
class Activity {
  final String title;
  final String imageUrl;
  final String date;
  final String views;
  final String tags;

  Activity({
    required this.title,
    required this.imageUrl,
    required this.date,
    required this.views,
    required this.tags,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'],
      imageUrl: json['imageUrl'],
      date: json['date'],
      views: json['views'],
      tags: json['tags'],
    );
  }
}

// 🌐 서버에서 활동 데이터 불러오기
Future<List<Activity>> fetchRecommendedActivities() async {
  /*final response = await http.get(Uri.parse('https://your.api/recommendations'));

  //if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((json) => Activity.fromJson(json)).toList();
  } else {
    throw Exception('추천 활동을 불러오지 못했습니다.');
  }*/
  await Future.delayed(const Duration(milliseconds: 500)); // 살짝 로딩 느낌

  return [
    Activity(
      title: 'CJ 제일제당 Future Marketer League',
      imageUrl: 'https://i.imgur.com/BoN9kdC.png', // 임시 이미지
      date: '04/10 마감',
      views: '800만원',
      tags: '#기획 아이디어 #광고 마케팅',
    ),
  ];
}


// ✅ 메인 위젯
class RecommendedActivityWidget extends StatelessWidget {
  const RecommendedActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Activity>>(
      future: fetchRecommendedActivities(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("에러가 발생했습니다."));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("추천 활동이 없습니다."));
        }

        final activities = snapshot.data!;
        return _buildActivitySection(activities);
      },
    );
  }

  Widget _buildActivitySection(List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 상단 텍스트
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '추천 활동',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Noto Sans KR',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.41,
                ),
              ),

              IconButton(
                padding: const EdgeInsets.only(right: 8),
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 24,
                  color: Color(0xFF008CFF),
                ),
                onPressed: () {
                  // 👉 여기에 이동 기능 또는 동작 넣기
                  print("화살표 눌림!");
                  // Navigator.push(...) 등 사용 가능
                },
              )
            ],
          ),
        ),

        //const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            '관심사 분석을 통해 사용자에게 맞춤형 활동을 추천합니다.',
            style: TextStyle(
              color: const Color(0xFF808080),
              fontSize: 12,
              fontFamily: 'Noto Sans KR',
              fontWeight: FontWeight.w400,
              letterSpacing: -0.20,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 🔹 활동 카드 리스트
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            itemCount: activities.length > 5 ? 5 : activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityCard(activity);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard(Activity activity) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF008CFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔸 상단 텍스트
          Text(
            activity.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // 🔸 이미지
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                activity.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 🔸 정보
          Text('📅 ${activity.date}', style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text('👁 ${activity.views}', style: const TextStyle(color: Colors.white, fontSize: 12)),
          Text(activity.tags, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
