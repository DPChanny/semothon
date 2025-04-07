import 'package:flutter_app/dto/get_room_list_response_dto.dart';
import 'package:flutter_app/dto/get_room_response_dto.dart';
import 'package:flutter_app/dto/room_update_dto.dart';
import 'package:flutter_app/services/queries/query.dart';

Future<void> createRoom(RoomUpdateDTO room) {
  return queryPost<void>('/api/rooms', body: room, expectedStatusCode: 201);
}

Future<GetRoomListResponseDto> getRoomList({
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
}) {
  final queryParams = <String, dynamic>{
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

  return queryGet<GetRoomListResponseDto>(
    '/api/rooms',
    (json) => GetRoomListResponseDto.fromJson(json),
    queryParams: queryParams,
  );
}

Future<GetRoomResponseDto> getRoom(int roomId) {
  return queryGet<GetRoomResponseDto>(
    'api/rooms/$roomId',
    (json) => GetRoomResponseDto.fromJson(json),
  );
}

Future<GetRoomResponseDto> joinRoom(int roomId) {
  return queryPost<GetRoomResponseDto>(
    'api/rooms/$roomId/join',
    fromJson: (json) => GetRoomResponseDto.fromJson(json),
  );
}

Future<void> leaveRoom(int roomId) {
  return queryPost<void>('api/rooms/$roomId/leave');
}
