import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/dto/crawling_info_dto.dart';
import 'package:flutter_app/widgets/crawling_item.dart';

class CrawlingTab extends StatelessWidget {
  List<CrawlingInfoDto>? crawlings;

  CrawlingTab({
    super.key,
    this.crawlings,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            _buildPersonalRecommendation(context),
            const SizedBox(height: 32),
            _buildLatestRecommendation(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ✅ 추천 활동 (PageView + crawlingItem)
  Widget _buildPersonalRecommendation(BuildContext context) {
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
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 170.44, // 🟡 아이템 크기와 정확히 맞춤
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              controller: PageController(
                viewportFraction:
                107.4 / MediaQuery.of(context).size.width, // 정확한 비율
              ),
              padEnds: false, // ✅ 맨 앞 빈 공간 제거
              itemCount: min(crawlings!.length, 5),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: crawlingItem(context, crawlings![index]),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  // ✅ 최신 추천 (예시용, 필요 없으면 삭제 가능)
  Widget _buildLatestRecommendation() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        '최신순으로 추천 활동을 확인해 보세요',
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }
}
