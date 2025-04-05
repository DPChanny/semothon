import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/dto/get_user_list_response_dto.dart';
import 'package:flutter_app/dto/get_user_response_dto.dart';
import 'package:flutter_app/dto/user_info_dto.dart';
import 'package:flutter_app/dto/user_update_dto.dart';
import 'package:flutter_app/dto/user_update_interest_dto.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/url.dart';
import 'package:http/http.dart' as http;

//로그인 후 유저 정보 조회
Future<({bool success, String message, UserInfoDto? user})> loginUser() async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", user: null);
  }

  final response = await http.post(
    url('/api/users/login'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (
      success: false,
      message: "server failure: $response.body",
      user: null,
    );
  }

  try {
    return (
      success: true,
      message: "succeed",
      user: UserInfoDto.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))['data']?['user'],
      ),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", user: null);
  }
}

// 현재 유저 정보
Future<({bool success, String message, GetUserResponseDto? user})>
getUser() async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", user: null);
  }

  final response = await http.get(
    url('/api/users/profile'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (
      success: false,
      message: "server failure: ${response.body}",
      user: null,
    );
  }

  try {
    return (
      success: true,
      message: "succeed",
      user: GetUserResponseDto.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))['data'],
      ),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", user: null);
  }
}

Future<({bool success, String message, GetUserResponseDto? user})> getOtherUser(
  String userId,
) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", user: null);
  }

  final response = await http.get(
    url('/api/users/profile/$userId'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (
      success: false,
      message: "server failure: ${response.body}",
      user: null,
    );
  }

  try {
    return (
      success: true,
      message: "succeed",
      user: GetUserResponseDto.fromJson(
        jsonDecode(utf8.decode(response.bodyBytes))['data'],
      ),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", user: null);
  }
}

// 유저 정보 업데이트
Future<({bool success, String message})> updateUser() async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure");
  }

  final response = await http.patch(
    url('/api/users/profile'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(UserUpdateDTO.instance.toJson()),
  );

  if (response.statusCode != 200) {
    return (success: false, message: "server failure: ${response.body}");
  }

  return (success: true, message: "succeed");
}

Future<({bool success, String message, String? introText})>
updateUserInterest() async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", introText: null);
  }

  final response = await http.put(
    url('/api/users/interests'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(UserUpdateInterestIntroDTO.instance.toInterestJson()),
  );

  if (response.statusCode != 200) {
    return (
      success: false,
      message: "server failure: ${response.body}",
      introText: null,
    );
  }

  try {
    final String text =
        jsonDecode(
          utf8.decode(response.bodyBytes),
        )['data']['generatedIntroText'];
    return (success: true, message: "succeed", introText: text);
  } catch (e) {
    return (success: false, message: "parsing failure: $e", introText: null);
  }
}

Future<({bool success, String message})> updateUserIntro() async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure");
  }

  final response = await http.put(
    url('/api/users/intro'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(UserUpdateInterestIntroDTO.instance.toIntroJson()),
  );

  if (response.statusCode != 200) {
    return (success: false, message: "server failure: ${response.body}");
  }

  return (success: true, message: "succeed");
}

Future<({bool success, String message, GetUserListResponseDto? userList})>
getUserList({
  String? nicknameKeyword,
  String? departmentKeyword,
  String? introKeyword,
  String? nameKeyword,
  String? keyword,
  String? birthdateAfter,
  String? birthdateBefore,
  List<String>? interestNames,
  double? minRecommendationScore,
  double? maxRecommendationScore,
  String? createdAfter,
  String? createdBefore,
  String? sortBy,
  String? sortDirection,
  int? limit,
  int? page,
}) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", userList: null);
  }

  // ✅ 쿼리 파라미터 정리
  final Map<String, dynamic> queryParams = {
    if (nicknameKeyword != null) 'nicknameKeyword': nicknameKeyword,
    if (departmentKeyword != null) 'departmentKeyword': departmentKeyword,
    if (introKeyword != null) 'introKeyword': introKeyword,
    if (nameKeyword != null) 'nameKeyword': nameKeyword,
    if (keyword != null) 'keyword': keyword,
    if (birthdateAfter != null) 'birthdateAfter': birthdateAfter,
    if (birthdateBefore != null) 'birthdateBefore': birthdateBefore,
    if (interestNames != null && interestNames.isNotEmpty)
      'interestNames': interestNames,
    if (minRecommendationScore != null)
      'minRecommendationScore': minRecommendationScore,
    if (maxRecommendationScore != null)
      'maxRecommendationScore': maxRecommendationScore,
    if (createdAfter != null) 'createdAfter': createdAfter,
    if (createdBefore != null) 'createdBefore': createdBefore,
    if (sortBy != null) 'sortBy': sortBy,
    if (sortDirection != null) 'sortDirection': sortDirection,
    if (limit != null) 'limit': limit,
    if (page != null) 'page': page,
  };

  // ✅ url 함수 활용
  final uri = url('/api/users', queryParams: queryParams);

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
      userList: null,
    );
  }

  try {
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    final userListDto = GetUserListResponseDto.fromJson(body['data']);
    return (success: true, message: "succeed", userList: userListDto);
  } catch (e) {
    return (success: false, message: "parsing failure: $e", userList: null);
  }
}

Future<({bool success, String message})> deleteUser() async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure");
  }

  final response = await http.delete(
    url('/api/users/prifile'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    return (success: false, message: "server failure: ${response.body}");
  }

  return (success: true, message: "succeed");
}