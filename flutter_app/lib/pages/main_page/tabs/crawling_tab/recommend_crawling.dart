import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/dto/crawling_info_dto.dart';

class CrawlingItem {
  final String imageUrl;
  final String title;
  final String description;
  final List<String> interest;

  CrawlingItem({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.interest,
  });
}

Widget _buildRecommendationCard(CrawlingItem item) {
  return Container(
    width: 334,
    height: 102.47,
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F6F8),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(12),
            child: Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, size: 50, color: Colors.grey),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: item.interest
                      .map((tag) => Text(
                            '#$tag',
                            style: const TextStyle(color: Colors.blue, fontSize: 12),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class RecommendationPage extends StatelessWidget {
  final List<CrawlingInfoDto> crawlingItems;

  const RecommendationPage({Key? key, required this.crawlingItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = crawlingItems.take(10).toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, // ✅ 상태바 아이콘 검정색
      child: Scaffold(
        backgroundColor: Colors.white, // ✅ 전체 배경 흰색
        appBar: AppBar(
          backgroundColor: Colors.white, // ✅ AppBar 배경도 흰색
          systemOverlayStyle: SystemUiOverlayStyle.dark, // ✅ 상태바 배경 흰색 + 아이콘 검정
          title: const Text('추천 활동'),
          foregroundColor: Colors.black, // ✅ 텍스트 검정
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AI의 맞춤 추천',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF007BFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: const Text(
                          '추천순',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F1F1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: const Text('최신순'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final dto = items[index];

                  final crawlingItem = CrawlingItem(
                    imageUrl: dto.imageUrl,
                    title: dto.title,
                    description: dto.description,
                    interest: dto.interests,
                  );

                  return _buildRecommendationCard(crawlingItem);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
