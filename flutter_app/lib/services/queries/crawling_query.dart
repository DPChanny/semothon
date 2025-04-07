import 'package:flutter_app/dto/crawling_update_dto.dart';
import 'package:flutter_app/dto/get_crawling_list_response_dto.dart';
import 'package:flutter_app/dto/get_crawling_response_dto.dart';
import 'package:flutter_app/services/queries/query.dart';

Future<GetCrawlingListResponseDto> getCrawlingList({
  List<String>? titleKeyword,
  List<String>? descriptionKeyword,
  List<String>? titleOrDescriptionKeyword,
  List<String>? interestNames,
  DateTime? deadlinedAfter,
  DateTime? deadlinedBefore,
  DateTime? crawledAfter,
  DateTime? crawledBefore,
  double? minRecommendationScore,
  double? maxRecommendationScore,
  String? sortBy,
  String? sortDirection,
  int? limit,
  int? page,
}) {
  final queryParams = <String, dynamic>{
    if (titleKeyword != null && titleKeyword.isNotEmpty)
      'titleKeyword': titleKeyword,
    if (descriptionKeyword != null && descriptionKeyword.isNotEmpty)
      'descriptionKeyword': descriptionKeyword,
    if (titleOrDescriptionKeyword != null &&
        titleOrDescriptionKeyword.isNotEmpty)
      'titleOrDescriptionKeyword': titleOrDescriptionKeyword,
    if (interestNames != null && interestNames.isNotEmpty)
      'interestNames': interestNames,
    if (deadlinedAfter != null)
      'deadlinedAfter': deadlinedAfter.toIso8601String(),
    if (deadlinedBefore != null)
      'deadlinedBefore': deadlinedBefore.toIso8601String(),
    if (crawledAfter != null) 'crawledAfter': crawledAfter.toIso8601String(),
    if (crawledBefore != null) 'crawledBefore': crawledBefore.toIso8601String(),
    if (minRecommendationScore != null)
      'minRecommendationScore': minRecommendationScore,
    if (maxRecommendationScore != null)
      'maxRecommendationScore': maxRecommendationScore,
    if (sortBy != null) 'sortBy': sortBy,
    if (sortDirection != null) 'sortDirection': sortDirection,
    if (limit != null) 'limit': limit,
    if (page != null) 'page': page,
  };

  return queryGet<GetCrawlingListResponseDto>(
    '/api/crawlings',
    (json) => GetCrawlingListResponseDto.fromJson(json),
    queryParams: queryParams,
  );
}

Future<GetCrawlingResponseDto> getCrawling(int crawlingId) {
  return queryGet<GetCrawlingResponseDto>(
    'api/crawlings/$crawlingId',
    (json) => GetCrawlingResponseDto.fromJson(json['crawling']),
  );
}

Future<void> createCrawling(int crawlingId, CrawlingUpdateDto crawling) {
  return queryPost<void>(
    '/api/crawlings/$crawlingId/chats',
    body: crawling,
    expectedStatusCode: 201,
  );
}

Future<GetCrawlingResponseDto> joinCrawling(int crawlingId, int chatRoomId) {
  return queryPost<GetCrawlingResponseDto>(
    'api/rooms/$crawlingId/chats/$chatRoomId/join',
    fromJson: (json) => GetCrawlingResponseDto.fromJson(json),
  );
}

Future<void> leaveCrawling(int crawlingId, int chatRoomId) {
  return queryPost<void>('api/crawlings/$crawlingId/chats/$chatRoomId/leave');
}
