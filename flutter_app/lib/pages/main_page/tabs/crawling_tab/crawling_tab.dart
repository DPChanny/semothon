import 'package:flutter/material.dart';

// ✅ 데이터 모델
class Activity {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tags;

  Activity({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tags,
  });
}

// ✅ 예시 데이터
final List<Activity> recommendedList = [
  Activity(
    title: '고양이 공모전',
    description: '귀여운 고양이를 자랑해 보세요!',
    imageUrl: 'https://placekitten.com/200/200',
    tags: ['고양이', '공모전'],
  ),
  Activity(
    title: '고양이 발바닥 공모전',
    description: '세상에서 가장 귀여운 발바닥을 찾아요',
    imageUrl: 'https://placekitten.com/201/200',
    tags: ['고양이', '귀여움'],
  ),
];

final List<Activity> latestList = [
  Activity(
    title: '고양이 공모전',
    description:
    '고양이는 귀엽다. 왜냐면 귀엽기 때문이다. 나도 귀엽다. 하지만 너는 고양이만큼은 아니다... 그래서...',
    imageUrl: 'https://placekitten.com/300/200',
    tags: ['코딩', '챌린지'],
  ),
];

class CrawlingTab extends StatelessWidget {
  const CrawlingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPersonalRecommendation(),
            const SizedBox(height: 24),
            _buildLatestRecommendation(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ✅ 개인화 추천
  Widget _buildPersonalRecommendation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '김세모',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      TextSpan(
                        text: '님에게 딱 맞는 활동은?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recommendedList.length,
            itemBuilder: (context, index) {
              final item = recommendedList[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(item.imageUrl, fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '#${item.tags.first}',
                      style:
                      const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ✅ 최신 추천
  Widget _buildLatestRecommendation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: const [
              Expanded(
                child: Text(
                  'New',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blue),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '최신순으로 추천 활동을 확인해 보세요',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.85),
            itemCount: latestList.length,
            itemBuilder: (context, index) {
              final item = latestList[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        item.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '#${item.tags.join(" #")}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
