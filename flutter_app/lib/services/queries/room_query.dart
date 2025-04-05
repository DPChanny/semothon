import 'dart:convert';

import 'package:flutter_app/dto/get_room_list_response_dto.dart';
import 'package:flutter_app/dto/get_room_response_dto.dart';
import 'package:flutter_app/dto/room_update_dto.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:flutter_app/services/url.dart';
import 'package:http/http.dart' as http;

Future<({bool success, String message})> createRoom(RoomUpdateDTO room) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure");
  }

  final response = await http.post(
    url('/api/rooms'),
    headers: {
      'Authorization': 'Bearer $idToken',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(room.toJson()),
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

Future<({bool success, String message, GetRoomListResponseDto? roomList})>
getRoomList({
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

  final uri = url('/api/rooms', queryParams: queryParams);

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
    final GetRoomListResponseDto roomList = GetRoomListResponseDto.fromJson(
      body['data'],
    );
    return (success: true, message: "succeed", roomList: roomList);
  } catch (e) {
    return (success: false, message: "parsing failure: $e", roomList: null);
  }
}

Future<({bool success, String message, GetRoomResponseDto? room})> getRoom(
  int roomId,
) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", room: null);
  }

  final response = await http.get(
    url("api/rooms/$roomId"),
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
      room: GetRoomResponseDto.fromJson(data),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", room: null);
  }
}

Future<({bool success, String message, GetRoomResponseDto? room})> joinRoom(
  int roomId,
) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure", room: null);
  }

  final response = await http.post(
    url("api/rooms/$roomId/join"),
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
      room: GetRoomResponseDto.fromJson(data),
    );
  } catch (e) {
    return (success: false, message: "parsing failure: $e", room: null);
  }
}

Future<({bool success, String message})> leaveRoom(int roomId) async {
  String? idToken = await getSafeIdToken();
  if (idToken == null) {
    return (success: false, message: "token failure");
  }

  final response = await http.post(
    url("api/rooms/$roomId/leave"),
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
