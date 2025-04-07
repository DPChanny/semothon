import 'package:flutter_app/dto/crawling/crawling_info_dto.dart';

class GetCrawlingListResponseDto {
  final List<CrawlingInfoDto> crawlingList;

  GetCrawlingListResponseDto({
    required this.crawlingList,
  });

  factory GetCrawlingListResponseDto.fromJson(Map<String, dynamic> json) {
    return GetCrawlingListResponseDto(
      crawlingList:
          (json['crawlingList'] as List)
              .map((e) => CrawlingInfoDto.fromJson(e['crawlingInfo']))
              .toList(),
    );
  }
}
