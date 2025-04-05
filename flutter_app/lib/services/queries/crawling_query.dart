import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/dto/crawling_update_dto.dart';
import 'package:flutter_app/dto/get_crawling_list_response_dto.dart';
import 'package:flutter_app/dto/get_crawling_response_dto.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/url.dart';
import 'package:http/http.dart' as http;

Future<
  ({bool success, String message, GetCrawlingListResponseDto? crawlingList})
>
getCrawlingList({
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
}) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", crawlingList: null);
  }

  final queryParams = <String, String>{};

  void addListParam(String key, List<String>? values) {
    if (values != null && values.isNotEmpty) {
      queryParams[key] = values.join(',');
    }
  }

  void addDateParam(String key, DateTime? value) {
    if (value != null) {
      queryParams[key] = value.toIso8601String();
    }
  }

  addListParam('titleKeyword', titleKeyword);
  addListParam('descriptionKeyword', descriptionKeyword);
  addListParam('titleOrDescriptionKeyword', titleOrDescriptionKeyword);
  addListParam('interestNames', interestNames);

  addDateParam('deadlinedAfter', deadlinedAfter);
  addDateParam('deadlinedBefore', deadlinedBefore);
  addDateParam('crawledAfter', crawledAfter);
  addDateParam('crawledBefore', crawledBefore);

  if (minRecommendationScore != null) {
    queryParams['minRecommendationScore'] = minRecommendationScore.toString();
  }
  if (maxRecommendationScore != null) {
    queryParams['maxRecommendationScore'] = maxRecommendationScore.toString();
  }
  if (sortBy != null) queryParams['sortBy'] = sortBy;
  if (sortDirection != null) queryParams['sortDirection'] = sortDirection;
  if (limit != null) queryParams['limit'] = limit.toString();
  if (page != null) queryParams['page'] = page.toString();

  final response = await http.get(
    url('/api/crawlings', queryParams: queryParams),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (
      success: false,
      message: "server failure: ${response.body}",
      crawlingList: null,
    );
  }

  try {
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    final GetCrawlingListResponseDto result =
        GetCrawlingListResponseDto.fromJson(body['data']);
    return (success: true, message: "succeed", crawlingList: result);
  } catch (e) {
    return (success: false, message: "parsing failure: $e", crawlingList: null);
  }
}

Future<({bool success, String message, GetCrawlingResponseDto? crawling})>
getCrawling(int crawlingId) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", crawling: null);
  }

  final response = await http.get(
    url("api/crawlings/$crawlingId"),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (
      success: false,
      message: "server failure: ${response.body}",
      crawling: null,
    );
  }

  try {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    final data = decoded['data']['crawling'];

    return (
      success: true,
      message: "succeed",
      crawling: GetCrawlingResponseDto.fromJson(data),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", crawling: null);
  }
}


Future<({bool success, String message})> createCrawling(int crawlingId, CrawlingUpdateDto crawling) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure");
  }

  final response = await http.post(
    url('/api/crawlings/$crawlingId/chats'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(crawling.toJson()),
  );

  if (response.statusCode != 201) {
    final responseBody = response.body;
    return (success: false, message: "server failure: $responseBody");
  }

  try {
    return (success: true, message: "succeed");
  } catch (e) {
    return (success: false, message: "parsing failure: $e");
  }
}

Future<({bool success, String message, GetCrawlingResponseDto? room})> joinCrawling(
    int crawlingId, int chatRoomId
    ) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", room: null);
  }

  final response = await http.post(
    url("api/rooms/$crawlingId/chats/$chatRoomId/join"),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (
    success: false,
    message: "server failure: ${response.body}",
    room: null,
    );
  }

  try {
    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    final data = decoded['data'];

    return (
    success: true,
    message: "succeed",
    room: GetCrawlingResponseDto.fromJson(data),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", room: null);
  }
}

Future<({bool success, String message})> leaveCrawling(int crawlingId, int chatRoomId) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure");
  }

  final response = await http.post(
    url("api/crawlings/$crawlingId/chats/$chatRoomId/leave"),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (success: false, message: "server failure: ${response.body}");
  }

  try {
    return (success: true, message: "succeed");
  } catch (e) {
    return (success: false, message: "parsing failure: $e");
  }
}
