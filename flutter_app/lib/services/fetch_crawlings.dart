import 'package:flutter_app/dto/crawling_dto.dart';

Future<List<CrawlingDto>> fetchCrawlingItems() async {
  await Future.delayed(const Duration(seconds: 1));
  return [
    CrawlingDto(
      crawlingId: 1,
      title: '현대자동차\nH-Startup 공모전',
      url: 'https://www.hyundai.com/kr/ko/company/newsroom',
      imageUrl: 'https://picsum.photos/seed/hyundai/500/300',
      description: '스타트업과 함께하는 현대자동차 공모전!',
      publishedAt: DateTime.now().add(const Duration(days: 12)),
      crawledAt: DateTime.now(),
    ),
    CrawlingDto(
      crawlingId: 2,
      title: '카카오엔터프라이즈\nAI 챌린지',
      url: 'https://www.kakaoenterprise.com/',
      imageUrl: 'https://picsum.photos/seed/kakao/500/300',
      description: 'AI 모델로 문제 해결! 카카오 공모전 참가하세요.',
      publishedAt: DateTime.now().add(const Duration(days: 18)),
      crawledAt: DateTime.now(),
    ),
  ];
}
