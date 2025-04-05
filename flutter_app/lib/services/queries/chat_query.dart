import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_app/dto/get_chat_list_response_dto.dart';
import 'package:flutter_app/dto/get_chat_response_dto.dart';
import 'package:flutter_app/dto/get_message_response_dto.dart';
import 'package:flutter_app/dto/get_unread_message_count_response_dto.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/url.dart';
import 'package:http/http.dart' as http;

Future<({bool success, String message, GetChatListResponseDto? roomList})>
getChatList({
  List<String>? titleKeyword,
  List<String>? descriptionKeyword,
  List<String>? titleOrDescriptionKeyword,
  String? hostUserId,
  String? hostNickname,
  List<String>? interestNames,
  int? minCapacity,
  int? maxCapacity,
  double? minRecommendationScore,
  double? maxRecommendationScore,
  bool? joinedOnly,
  bool? excludeJoined,
  String? createdAfter,
  String? createdBefore,
  String? sortBy,
  String? sortDirection,
  int? limit,
  int? page,
}) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", roomList: null);
  }

  final Map<String, dynamic> queryParams = {
    if (titleKeyword != null && titleKeyword.isNotEmpty)
      'titleKeyword': titleKeyword,
    if (descriptionKeyword != null && descriptionKeyword.isNotEmpty)
      'descriptionKeyword': descriptionKeyword,
    if (titleOrDescriptionKeyword != null &&
        titleOrDescriptionKeyword.isNotEmpty)
      'titleOrDescriptionKeyword': titleOrDescriptionKeyword,
    if (hostUserId != null) 'hostUserId': hostUserId,
    if (hostNickname != null) 'hostNickname': hostNickname,
    if (interestNames != null && interestNames.isNotEmpty)
      'interestNames': interestNames,
    if (minCapacity != null) 'minCapacity': minCapacity,
    if (maxCapacity != null) 'maxCapacity': maxCapacity,
    if (minRecommendationScore != null)
      'minRecommendationScore': minRecommendationScore,
    if (maxRecommendationScore != null)
      'maxRecommendationScore': maxRecommendationScore,
    if (joinedOnly != null) 'joinedOnly': joinedOnly,
    if (excludeJoined != null) 'excludeJoined': excludeJoined,
    if (createdAfter != null) 'createdAfter': createdAfter,
    if (createdBefore != null) 'createdBefore': createdBefore,
    if (sortBy != null) 'sortBy': sortBy,
    if (sortDirection != null) 'sortDirection': sortDirection,
    if (limit != null) 'limit': limit,
    if (page != null) 'page': page,
  };

  final uri = url('/api/chats', queryParams: queryParams);

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
      roomList: null,
    );
  }

  try {
    final body = jsonDecode(utf8.decode(response.bodyBytes));
    final GetChatListResponseDto roomList = GetChatListResponseDto.fromJson(
      body['data'],
    );
    return (success: true, message: "succeed", roomList: roomList);
  } catch (e) {
    return (success: false, message: "parsing failure: $e", roomList: null);
  }
}

Future<({bool success, String message, GetChatResponseDto? room})> getChat(
  int chatId,
) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", room: null);
  }

  final response = await http.get(
    url("api/chats/$chatId"),
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
      room: GetChatResponseDto.fromJson(data),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", room: null);
  }
}

Future<({bool success, String message, GetMessageResponseDto? room})>
getChatMessage(int chatId) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", room: null);
  }

  final response = await http.get(
    url("api/chats/$chatId/messages"),
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
      room: GetMessageResponseDto.fromJson(data),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", room: null);
  }
}

Future<({bool success, String message, GetUnreadMessageCountResponseDto? room})>
getUnreadMessageCount() async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", room: null);
  }

  final response = await http.get(
    url("api/chats/unread-count"),
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
      room: GetUnreadMessageCountResponseDto.fromJson(data),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", room: null);
  }
}
