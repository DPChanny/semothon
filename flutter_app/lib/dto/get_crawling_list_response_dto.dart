import 'package:flutter_app/dto/crawling_info_dto.dart';

class GetCrawlingListResponseDto {
  final List<CrawlingInfoDto> crawlingList;
  final int totalCount;

  GetCrawlingListResponseDto({
    required this.crawlingList,
    required this.totalCount,
  });

  factory GetCrawlingListResponseDto.fromJson(Map<String, dynamic> json) {
    return GetCrawlingListResponseDto(
      crawlingList:
          (json['crawlingList'] as List)
              .map((e) => CrawlingInfoDto.fromJson(e['crawlingInfo']))
              .toList(),
      totalCount: json['totalCount'],
    );
  }
}
