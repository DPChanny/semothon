import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/dto/get_crawling_list_response_dto.dart';
import 'package:flutter_app/services/url.dart';
import 'package:http/http.dart' as http;

Future<({bool success, String message, GetCrawlingListResponseDto? crawlingList})> getCrawlingList() async {
  String? idToken;
  try {
    idToken = await FirebaseAuth.instance.currentUser!.getIdToken(true);
  } catch (e) {
    return (success: false, message: "firebase failure $e", crawlingList: null);
  }

  if (idToken == null) {
    return (success: false, message: "token failure", crawlingList: null);
  }

  final uri = url('/api/crawling'); // 실제 서버 경로에 맞게 수정

  final response = await http.get(
    uri,
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
    final GetCrawlingListResponseDto result = GetCrawlingListResponseDto.fromJson(body['data']);
    return (
    success: true,
    message: "succeed",
    crawlingList: result,
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", crawlingList: null);
  }
}
